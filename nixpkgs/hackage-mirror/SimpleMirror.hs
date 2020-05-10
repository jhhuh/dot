{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE ViewPatterns #-}

{-# OPTIONS_GHC -fno-warn-orphans #-}

module Main where

import qualified Codec.Archive.Tar as Tar
import qualified Codec.Archive.Tar.Entry as Tar
import           Control.Applicative
import           Control.Concurrent.Async.Lifted
import           Control.Concurrent.STM
import           Control.Exception.Lifted
import           Control.Logging
import           Control.Monad hiding (forM_)
import           Control.Monad.IO.Class
import           Control.Monad.Morph
import           Control.Monad.Trans.Control
import           Control.Monad.Trans.Resource
import qualified Crypto.Hash.SHA512 as SHA512
import           Data.ByteString (ByteString)
import qualified Data.ByteString.Lazy as BL
import           Data.Conduit
import qualified Data.Conduit.Binary as CB
import qualified Data.Conduit.Lazy as CL
import qualified Data.Conduit.List as CL
import           Data.Conduit.Zlib as CZ
import qualified Data.HashMap.Strict as M
import           Data.List
import           Data.Monoid ((<>))
import           Data.Serialize hiding (label)
import qualified Data.Text as T
import qualified Data.Text.Encoding as T
import           Network.HTTP.Conduit hiding (Response)
import           Options.Applicative as Opt
import           Prelude
import           System.Directory
import           System.FilePath
import           System.IO
import           System.IO.Temp

data Options = Options
    { verbose     :: Bool
    , rebuild     :: Bool
    , mirrorFrom  :: String
    , mirrorTo    :: String
    }

defaultOptions :: Options
defaultOptions = Options
    { verbose     = False
    , rebuild     = False
    , mirrorFrom  = ""
    , mirrorTo    = ""
    }

hackageBaseUrl :: String
hackageBaseUrl = "http://hackage.haskell.org"

options :: Opt.Parser Options
options = Options
    <$> switch (long "verbose" <> help "Display verbose output")
    <*> switch (long "rebuild" <> help "Don't mirror; used for rebuilding")
    <*> strOption (long "from" <> value hackageBaseUrl
                   <> help "Base URL to mirror from")
    <*> strOption (long "to" <> help "Base URL of server mirror to")

data Package = Package
    { packageName       :: !String
    , packageVersion    :: !String
    , packageCabal      :: !BL.ByteString
    , packageIdentifier :: !ByteString
    , packageTarEntry   :: !Tar.Entry
    }

packageFullName :: Package -> String
packageFullName Package {..} = packageName <> "-" <> packageVersion

data PathKind = UrlPath | FilePath

pathKind :: String -> PathKind
pathKind url
    | "http://" `isPrefixOf` url || "https://" `isPrefixOf` url = UrlPath
    | otherwise = FilePath

indexPackages :: (MonadThrow m, MonadBaseControl IO m, CL.MonadActive m)
              => Source m ByteString -> Source m Package
indexPackages src = do
    lbs <- lift $ CL.lazyConsume src
    sinkEntries $ Tar.read (BL.fromChunks lbs)
  where
    sinkEntries (Tar.Next ent entries)
        | Tar.NormalFile cabal _ <- Tar.entryContent ent = do
            case splitDirectories (Tar.entryPath ent) of
                [name, vers, _] ->
                    yield $ Package name vers cabal
                        (T.encodeUtf8 (T.pack (name <> vers))) ent
                ["preferred-versions"]    -> return ()
                [_, "preferred-versions"] -> return ()
                xs -> errorL' $ "Failed to parse package name: "
                           <> T.pack (Tar.entryPath ent) <> " ("
                           <> T.pack (show xs) <> ")"
            sinkEntries entries
        | otherwise = sinkEntries entries
    sinkEntries Tar.Done = return ()
    sinkEntries (Tar.Fail e) =
        monadThrow $ userError $ "Failed to read tar file: " ++ show e

downloadFromUrl :: (MonadResource m, MonadBaseControl IO m)
                => Manager -> String -> String -> Source m ByteString
downloadFromUrl mgr path file = do
    req  <- lift $ parseUrl (path </> file)
    resp <- lift $ http req mgr
    (src, _fin) <- lift $ unwrapResumable (responseBody resp)
    src

downloadFromPath :: MonadResource m => String -> String -> Source m ByteString
downloadFromPath path file = do
    let p = path </> file
    exists <- liftIO $ doesFileExist p
    when exists $ CB.sourceFile p

download :: (MonadResource m, MonadBaseControl IO m)
         => Manager
         -> String               -- ^ The server path, like /tmp/foo
         -> String               -- ^ The file's path within the server path
         -> Source m ByteString
download mgr path@(pathKind -> UrlPath) = downloadFromUrl mgr path
download _ path = downloadFromPath path

upload :: (MonadResource m, m ~ ResourceT IO)
       => Manager
       -> String
       -> String
       -> Source m ByteString
       -> m ()
upload _ path file src = do
    let p = path </> file
    liftIO $ createDirectoryIfMissing True (takeDirectory p)
    src $$ CB.sinkFile p

main :: IO ()
main = withStdoutLogging $ execParser opts >>= mirrorHackage
  where
    opts = info (helper <*> options)
                (fullDesc
                 <> progDesc "Mirror the necessary parts of Hackage"
                 <> header "simple-mirror - mirror only the minimum")

mirrorHackage :: Options -> IO ()
mirrorHackage Options {..} = withManager $ \mgr -> do
    sums <- getChecksums mgr
    putChecksums mgr "00-checksums.bak" sums
    newSums <- liftIO $ newTVarIO sums
    changed <- liftIO $ newTVarIO False
    void $ go mgr sums newSums changed `finally` do
        ch <- liftIO $ readTVarIO changed
        when ch $ do
            sums' <- liftIO $ readTVarIO newSums
            putChecksums mgr "00-checksums.dat" sums'
  where
    go mgr sums newSums changed = do
        ents <- CL.lazyConsume $
            getEntries mgr $= processEntries mgr sums newSums changed

        -- Use a temp file as a "backing store" to accumulate the new tarball.
        -- Only when it is complete and we've reached the end normally do we
        -- copy the file onto the server.  The checksum file is saved in all
        -- cases so that we know what we mirrored in this session; the index
        -- file, meanwhile, is always valid (albeit temporarily out-of-date if
        -- we abort due to an exception).
        withTemp "index" $ \temp -> do
            CB.sourceLbs (Tar.write ents)
                $= CZ.compress 7 (WindowBits 31) -- gzip compression
                $$ CB.sinkFile temp

            -- Writing the tarball is what causes the changed bit to be
            -- calculated, so we write it first to a temp file and then only
            -- upload it if necessary.
            ch <- liftIO $ readTVarIO changed
            when ch $ void $ do
                _ <- push mgr "00-index.tar.gz" $ CB.sourceFile temp
                log' "Uploaded 00-index.tar.gz"

    processEntries mgr sums newSums changed =
        CL.mapMaybeM $ \pkg@(Package {..}) -> do
            let sha = SHA512.hashlazy packageCabal
                et  = Tar.entryTime packageTarEntry
                new = case M.lookup packageIdentifier sums of
                    Nothing -> True
                    Just (et', _sha') -> et /= et' -- || sha /= sha'
            valid <- if new
                     then mirror mgr pkg sha newSums changed
                     else return True
            return $ mfilter (const valid) (Just packageTarEntry)

    mirror mgr pkg sha newSums changed = do
        let fname = packageFullName pkg
            dir   = "package" </> fname
            upath = addExtension dir ".tar.gz"
            dpath = dir </> addExtension fname ".tar.gz"
            cabal = dir </> addExtension (packageName pkg) ".cabal"
        (el, er) <-
            if rebuild
            then return (Right (), Right ())
            else do
                res <- concurrently
                    (push mgr upath $ download mgr mirrorFrom dpath)
                    (push mgr cabal $ CB.sourceLbs (packageCabal pkg))
                log' $ T.pack fname
                return res
        case (el, er) of
            (Right (), Right ()) -> liftIO $ atomically $ do
                writeTVar changed True
                modifyTVar newSums $
                    M.insert (packageIdentifier pkg)
                        (Tar.entryTime (packageTarEntry pkg), sha)
                return True
            _ -> return False

    push mgr file src = do
        eres <- try $ liftResourceT $ upload mgr mirrorTo file src
        case eres of
            Right () -> return ()
            Left e -> do
                let msg = T.pack (show (e :: SomeException))
                unless ("No tarball exists for this package version"
                        `T.isInfixOf` msg) $
                    warn' $ "FAILED " <> T.pack file <> ": " <> msg
        return eres

    getChecksums mgr = do
        sums <- download mgr mirrorTo "00-checksums.dat" $$ CB.sinkLbs
        log' $ "Downloaded checksums.dat from " <> T.pack mirrorTo
        return $ if BL.null sums
                 then M.empty
                 else case decodeLazy sums of
                     Left _    -> M.empty
                     Right res -> M.fromList res

    putChecksums mgr file sums = do
        _ <- push mgr file $ yield (encode (M.toList sums))
        log' $ "Uploaded " <> T.pack file

    getEntries mgr = do
        log' $ "Downloading index.tar.gz from " <> T.pack mirrorFrom
        indexPackages $
            download mgr mirrorFrom "00-index.tar.gz" $= CZ.ungzip

    withTemp prefix f = control $ \run ->
        withSystemTempFile prefix $ \temp h -> hClose h >> run (f temp)
