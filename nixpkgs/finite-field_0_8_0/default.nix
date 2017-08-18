{ mkDerivation, base, containers, deepseq, hashable, HUnit, primes
, QuickCheck, stdenv, template-haskell, test-framework
, test-framework-hunit, test-framework-quickcheck2
, test-framework-th, type-level-numbers
}:
mkDerivation {
  pname = "finite-field";
  version = "0.8.0";
  sha256 = "0wlbq7dpb4545xdnqjqppp0cmjx9m8g1p6lydkvn7pj7dwar8lni";
  libraryHaskellDepends = [
    base deepseq hashable template-haskell type-level-numbers
  ];
  testHaskellDepends = [
    base containers HUnit primes QuickCheck test-framework
    test-framework-hunit test-framework-quickcheck2 test-framework-th
    type-level-numbers
  ];
  description = "Finite Fields";
  license = stdenv.lib.licenses.bsd3;
}
