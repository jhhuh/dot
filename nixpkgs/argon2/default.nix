{ mkDerivation, base, bytestring, QuickCheck, stdenv, tasty
, tasty-quickcheck, text, transformers
}:
mkDerivation {
  pname = "argon2";
  version = "1.2.0";
  sha256 = "1zzwlhb47ykqi6psgnpzmf4nlk5rwr4adpl7sz7x7iacy9xmayd5";
  libraryHaskellDepends = [ base bytestring text transformers ];
  testHaskellDepends = [
    base bytestring QuickCheck tasty tasty-quickcheck text
  ];
  doCheck = false;
  homepage = "https://github.com/ocharles/argon2.git";
  description = "Haskell bindings to libargon2 - the reference implementation of the Argon2 password-hashing function";
  license = stdenv.lib.licenses.bsd3;
}
