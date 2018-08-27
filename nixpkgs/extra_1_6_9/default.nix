{ mkDerivation, base, clock, directory, filepath, process
, QuickCheck, stdenv, time, unix
}:
mkDerivation {
  pname = "extra";
  version = "1.6.9";
  sha256 = "2bc8cf7bd00e08f99cd6e55f7405f1b9d3950d84ef28e32b4b91bf0bc0baac77";
  libraryHaskellDepends = [
    base clock directory filepath process time unix
  ];
  testHaskellDepends = [ base directory filepath QuickCheck unix ];
  homepage = "https://github.com/ndmitchell/extra#readme";
  description = "Extra functions I use";
  license = stdenv.lib.licenses.bsd3;
}
