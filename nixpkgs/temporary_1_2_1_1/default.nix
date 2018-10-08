{ mkDerivation, base, base-compat, directory, exceptions, filepath
, stdenv, tasty, tasty-hunit, transformers, unix
}:
mkDerivation {
  pname = "temporary";
  version = "1.2.1.1";
  sha256 = "55772471e59529f4bde9555f6abb21d19a611c7d70b13befe114dc1a0ecb00f3";
  libraryHaskellDepends = [
    base directory exceptions filepath transformers unix
  ];
  testHaskellDepends = [
    base base-compat directory filepath tasty tasty-hunit unix
  ];
  homepage = "https://github.com/feuerbach/temporary";
  description = "Portable temporary file and directory support";
  license = stdenv.lib.licenses.bsd3;
}
