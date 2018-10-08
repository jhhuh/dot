{ mkDerivation, base, ghc-prim, stdenv }:
mkDerivation {
  pname = "basement";
  version = "0.0.7";
  sha256 = "b501b9b378f35b80c60321031dbbf9ed7af46c66353f072e00f00abdd2244f70";
  revision = "1";
  editedCabalFile = "005r4w6bks8fpxq1idn42ixb1fs1cjjfl4d5qh0zfskil1cqwaj4";
  libraryHaskellDepends = [ base ghc-prim ];
  homepage = "https://github.com/haskell-foundation/foundation";
  description = "Foundation scrap box of array & string";
  license = stdenv.lib.licenses.bsd3;
}
