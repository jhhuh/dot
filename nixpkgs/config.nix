{ pkgs }:

let

  nightlyPath = builtins.getEnv "HOME" + "/repo/nixpkgs-nightly";
  nightly = import nightlyPath {
    config = {}; # important to avoid an infinite recrusion
  };

  inherit (pkgs) callPackage stdenv;

in {

  allowUnfree = true;
  allowBroken = true;

  packageOverrides = pkgs: rec {

    inherit (nightly) yasr;

    my-python = pkgs.python3.withPackages (
      pypkgs: with pypkgs; [
        jupyter numpy scipy matplotlib ]);

    tcplay = callPackage ./tcplay {};
    speechd = pkgs.speechd.override { withEspeak = true; };
    flite = nightly.flite.overrideDerivation (attr:{
      nativeBuildInputs = [ pkgs.alsaLib.dev ];
      configureFlags = attr.configureFlags + " --with-audio=alsa";
      LDFLAGS = "-L ${pkgs.alsaLib.dev}/lib";
    });
    eflite = nightly.eflite.override { flite = flite; debug = true; };

       # WIP
    rustNightly = pkgs.recurseIntoAttrs (nightly.callPackage (nightlyPath+"/pkgs/development/compilers/rust/nightly.nix") {});
    alacritty = callPackage ./alacritty {
      inherit (pkgs.xorg) libXcursor libXxf86vm libXi;
      rustPlatform = pkgs.makeRustPlatform rustNightly;
    };

  };
}
