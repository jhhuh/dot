{ stdenv, fetchFromGitHub
, cmake, pkgconfig
, libgcrypt, libuuid, devicemapper, libudev, openssl, libgpgerror }:

stdenv.mkDerivation rec {
  name = "tcplay-${version}";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "bwalex";
    repo = "tc-play";
    rev = "v${version}";
    sha256 = "1lfnn1d0hz9w39ywv7fnjf9b9nffxi08w4khdvjdd15hdhy7yfg9";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libudev libuuid libgcrypt devicemapper openssl libgpgerror ];

#  NIX_CFLAGS_COMPILE = "-fPIC";

  meta = {
    description = "Free and simple TrueCrypt Implementation based on dm-crypt";
    license = stdenv.lib.licenses.bsd2;
  };
}
