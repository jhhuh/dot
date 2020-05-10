{ mkDerivation, base, bytestring, cereal, conduit, conduit-extra
, cryptohash, directory, filepath, http-conduit, lifted-async
, lifted-base, logging, mmorph, monad-control, optparse-applicative
, resourcet, stdenv, stm, tar, temporary, text, transformers
, unordered-containers
}:
mkDerivation {
  pname = "simple-mirror";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    base bytestring cereal conduit conduit-extra cryptohash directory
    filepath http-conduit lifted-async lifted-base logging mmorph
    monad-control optparse-applicative resourcet stm tar temporary text
    transformers unordered-containers
  ];
  homepage = "http://fpcomplete.com";
  description = "Simple mirroring utility for Hackage";
  license = stdenv.lib.licenses.bsd3;
}
