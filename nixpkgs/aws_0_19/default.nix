{ mkDerivation, aeson, attoparsec, base, base16-bytestring
, base64-bytestring, blaze-builder, byteable, bytestring
, case-insensitive, cereal, conduit, conduit-combinators
, conduit-extra, containers, cryptonite, data-default, directory
, errors, filepath, http-client, http-client-tls, http-conduit
, http-types, lifted-base, memory, monad-control, mtl, network
, old-locale, QuickCheck, quickcheck-instances, resourcet, safe
, scientific, stdenv, tagged, tasty, tasty-hunit, tasty-quickcheck
, text, time, transformers, transformers-base, unordered-containers
, utf8-string, vector, xml-conduit
}:
mkDerivation {
  pname = "aws";
  version = "0.19";
  sha256 = "b43b1215405a2c34b9e7ddac8a9f3cf80fff0f031b365a5c0e4e423f45b5777a";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson attoparsec base base16-bytestring base64-bytestring
    blaze-builder byteable bytestring case-insensitive cereal conduit
    conduit-extra containers cryptonite data-default directory filepath
    http-conduit http-types lifted-base memory monad-control mtl
    network old-locale resourcet safe scientific tagged text time
    transformers unordered-containers utf8-string vector xml-conduit
  ];
  testHaskellDepends = [
    aeson base bytestring conduit-combinators errors http-client
    http-client-tls http-types lifted-base monad-control mtl QuickCheck
    quickcheck-instances resourcet tagged tasty tasty-hunit
    tasty-quickcheck text time transformers transformers-base
  ];
  homepage = "http://github.com/aristidb/aws";
  description = "Amazon Web Services (AWS) for Haskell";
  license = stdenv.lib.licenses.bsd3;
}
