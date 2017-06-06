import XMonad
import XMonad.Config.Desktop (desktopConfig)

import XMonad.Hooks.DynamicLog (xmobar, dynamicLogString, xmonadPropLog)

import XMonad.Prompt.Shell (shellPrompt)
import XMonad.Prompt.Ssh (sshPrompt)
import XMonad.Util.NamedScratchpad ( namedScratchpadAction
                                   , namedScratchpadManageHook
                                   , customFloating
                                   , NamedScratchpad (NS) )

import qualified XMonad.StackSet as W

import XMonad.Util.Run (spawnPipe)

import qualified Data.Map as M
import qualified Data.Char as C

main = do spawn "~/.xmonad/xmobar.sh ~/.xmonad/xmobar.hs"
          xmonad conf
  where

    conf = desktopConfig { borderWidth = 2
                         , terminal = "urxvt"
                         , modMask = mod4Mask
                         , keys = myKeys <+> keys desktopConfig
                         , manageHook = scratchpadHook <+> manageHook desktopConfig <+> myManageHook
                         , startupHook = spawn "xset r rate 250 50"
                         , logHook = dynamicLogString def >>= xmonadPropLog
                         }
    scratchpads = [ NS "htop" "xterm -rv -e htop" (title =? "htop") ( customFloating $ W.RationalRect (1/6) (1/6) (1/3) (2/3) ),
                    NS "ncmpcpp" "xterm -rv -e ncmpcpp" (title =? "ncmpcpp") ( customFloating $ W.RationalRect (1/2) (1/6) (1/3) (2/3) )
                  ]

    myKeys XConfig { modMask = modm } =
      M.fromList [ ((modm, xK_p), shellPrompt def)
                 , ((modm .|. controlMask, xK_s), sshPrompt def)
                 , ((modm .|. controlMask, xK_t), namedScratchpadAction scratchpads "htop")
                 , ((modm .|. controlMask, xK_m), namedScratchpadAction scratchpads "ncmpcpp")
                 ]

    scratchpadHook = namedScratchpadManageHook scratchpads

    myManageHook = composeAll . concat $
      [ [ className   =? c --> doFloat           | c <- myFloatsByClass ]
      , [ title       =? t --> doFloat           | t <- myFloatsByTitle ]
      , [ className   =? c --> doF (W.shift "2") | c <- webApps ] ]
      where myFloatsByClass = concatMap (\s -> [ s, capitalize s ]) []
            myFloatsByTitle = [ "Open Document" ]
            webApps         = [ "Google-chrome" ]

    capitalize :: String -> String
    capitalize (c:cs) = C.toUpper c : cs
    capitalize [] = []
