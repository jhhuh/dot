{stdenv,fetchurl,alsaLib,bluez,glib,sbc,ortp,fdk_aac,libbsd,ncurses,autoconf,automake,libtool,pkgconfig}:

stdenv.mkDerivation rec {
  name = "bluealsa-${version}";
  version = "1.1.0";
  src = fetchurl {
    url = "https://github.com/Arkq/bluez-alsa/archive/v${version}.tar.gz";
    sha256 = "0yaibwlvmn81dz4z2n2sqxg1zlnyb607nz4hsn1r4vqr3ic6wfck";
  };
  configureFlags = "--enable-aac --enable-debug";
  preConfigure = "autoreconf --install";
  buildInputs = [ alsaLib bluez glib sbc ortp fdk_aac libbsd ncurses autoconf automake libtool pkgconfig ];
}
