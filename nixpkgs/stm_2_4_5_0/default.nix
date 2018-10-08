{ mkDerivation, array, base, stdenv }:
mkDerivation {
  pname = "stm";
  version = "2.4.5.0";
  sha256 = "31d7db183f13beed5c71409d12747a7f4cf3e145630553dc86336208540859a7";
  libraryHaskellDepends = [ array base ];
  homepage = "https://wiki.haskell.org/Software_transactional_memory";
  description = "Software Transactional Memory";
  license = stdenv.lib.licenses.bsd3;
}
