{ pkgs }: {

  allowUnfree = true;

  allowBroken = true;

  mplayer.pulseSupport = true;

  permittedInsecurePackages = [
    "nodejs-16.20.2"
  ];

}
