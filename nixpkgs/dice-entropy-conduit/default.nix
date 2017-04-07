{ mkDerivation, base, bytestring, conduit, entropy, QuickCheck
, stdenv, test-framework, test-framework-quickcheck2, transformers
}:
mkDerivation {
  pname = "dice-entropy-conduit";
  version = "1.0.0.1";
  sha256 = "01xwxajwyvv6ac48j9if6xsv05aqg1p02i7d25ivk1k56ky41l1s";
  libraryHaskellDepends = [
    base bytestring conduit entropy transformers
  ];
  testHaskellDepends = [
    base QuickCheck test-framework test-framework-quickcheck2
  ];
  doCheck = false;
  homepage = "http://monoid.at/code";
  description = "Cryptographically secure n-sided dice via rejection sampling";
  license = stdenv.lib.licenses.lgpl21;
}
