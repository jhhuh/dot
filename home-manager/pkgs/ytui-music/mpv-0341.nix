{ fetchFromGitHub, mpv-unwrapped }:

mpv-unwrapped.overrideAttrs (old: rec {
    version = "0.34.1";
    src = fetchFromGitHub {
      owner = "mpv-player";
      repo = "mpv";
      rev = "v${version}";
      sha256 = "sha256-Uz8MFEtlC69aVJD/SsdP0QULVA9ye0Rbk3AXzkPlHYs=";
    };
  })
