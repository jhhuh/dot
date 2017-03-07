{stdenv,fetchFromGitHub,alsaLib,bluez,glib,sbc,ortp,fdk_aac,libbsd,ncurses,autoconf,automake,libtool,pkgconfig}:

stdenv.mkDerivation rec {
  name = "bluez-alsa-${version}";
  version = "HEAD";
  src = fetchFromGitHub {
    owner = "Arkq";
    repo = "bluez-alsa";
    rev = "217cdde52b203798829242d8bea84871eec7fff2";
    sha256 = "13yy4fc5zsm7kmzy7nvqss7gkjjkrxgg5pw2cgw34mapy73mr0yj";
  };
  configureFlags = "--enable-aac --enable-debug";
  preConfigure = "autoreconf --install";
  buildInputs = [ alsaLib bluez glib sbc ortp fdk_aac libbsd ncurses autoconf automake libtool pkgconfig ];
}
