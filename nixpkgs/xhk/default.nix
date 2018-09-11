{stdenv, fetchFromGitHub, autoreconfHook, libX11, libXtst, libXi, libXext, pkgconfig}:

stdenv.mkDerivation rec {
  name = "xhk-${version}";
  version = "head";
  src = fetchFromGitHub {
    owner = "kbingham";
    repo = "xhk";
    rev = "7ea3c27e9815e492876c0f1d85a6d9bd4d8f87a7";
    sha256 = "1wlypw5ijji162xyd7rsvmvc395lzimcrwn3c6yx30mkm1r3rcca";
  };
  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ libX11 libXtst libXi libXext ];
}
