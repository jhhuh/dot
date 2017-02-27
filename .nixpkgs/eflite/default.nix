{stdenv,fetchurl,flite}:

stdenv.mkDerivation rec {
  name = "eflite-${version}";
  version = "0.4.1";
  src = fetchurl {
    url = "https://sourceforge.net/projects/eflite/files/eflite/${version}/${name}.tar.gz";
    sha256 = "088p9w816s02s64grfs28gai3lnibzdjb9d1jwxzr8smbs2qbbci";
  };
  buildInputs = [ flite ];
  configureFlags = "flite_dir=${flite} CFLAGS=-DDEBUG=2";
  patches = [
    ./buf-overflow
    ./cvs-update
    ./link
  ];
  hardeningDisable = [ "format" ];
}
