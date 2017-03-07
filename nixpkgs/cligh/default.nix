{stdenv,fetchurl,pythonPackages,pyGithub}:

with pythonPackages;
buildPythonPackage rec {
  name = "cligh-${version}";
  version = "0.3";
  src = fetchurl {
    url = "https://github.com/CMB/cligh/archive/v0.3.tar.gz";
    sha256 = "0779v3g9q656crs7hiakhmkr8207qiqyn67brl67iz1cbccnhwid";
  };
  propagatedBuildInputs = [ pyxdg pyGithub ];
  configureFlags = "";
  patches = [];
}
