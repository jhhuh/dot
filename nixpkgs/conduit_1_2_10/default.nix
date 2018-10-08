{ mkDerivation, base, containers, criterion, deepseq, exceptions
, hspec, kan-extensions, lifted-base, mmorph, monad-control, mtl
, mwc-random, primitive, QuickCheck, resourcet, safe, split, stdenv
, transformers, transformers-base, vector
}:
mkDerivation {
  pname = "conduit";
  version = "1.2.10";
  sha256 = "d1167adea7da849a2636418926006546dce4cbde5ba324ade83416a691be58dd";
  libraryHaskellDepends = [
    base exceptions lifted-base mmorph monad-control mtl primitive
    resourcet transformers transformers-base
  ];
  testHaskellDepends = [
    base containers exceptions hspec mtl QuickCheck resourcet safe
    split transformers
  ];
  benchmarkHaskellDepends = [
    base containers criterion deepseq hspec kan-extensions mwc-random
    transformers vector
  ];
  homepage = "http://github.com/snoyberg/conduit";
  description = "Streaming data processing library";
  license = stdenv.lib.licenses.mit;
}
