{stdenv,fetchurl,alsaLib,bluez,glib,sbc,ortp,fdk_aac,libbsd,ncurses,autoconf,automake,libtool,pkgconfig}:

stdenv.mkDerivation rec {
  name = "BlueALSA-${version}";
  version = "1.2.0";
  src = fetchurl {
    url = "https://github.com/Arkq/bluez-alsa/archive/v${version}.tar.gz";
    sha256 = "0f38jfgk2y7sfk106c19v3bwx0b6fdjj66pa62xwcphkrzl2fyha";
  };
  configureFlags = [ "--enable-aac" "--enable-debug" "--with-plugindir=$out/lib/alsa-lib"];
  preConfigure = "autoreconf --install";
  buildInputs = [ alsaLib bluez glib sbc ortp fdk_aac libbsd ncurses autoconf automake libtool pkgconfig ];
}
