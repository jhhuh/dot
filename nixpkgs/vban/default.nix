{stdenv, fetchFromGitHub, automake, autoconf, alsaLib, libpulseaudio, libjack2}:

stdenv.mkDerivation rec {
  name = "vban-${version}";
  version = "head";

  src = fetchFromGitHub {
    owner = "quiniouben";
    repo = "vban";
    rev = "17e9d094845891f702811babd28cbd07426f5249";
    sha256 = "15z7nr85jvzd7fwprxs3rzs1qdfdpy5r7fg402zvrfkf5ahqaj94";
  };

  buildInputs = [ automake autoconf alsaLib libpulseaudio libjack2 ];
  preConfigure = "./autogen.sh";
}

