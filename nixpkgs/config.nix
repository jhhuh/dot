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

    inherit (nightly) yasr texlive;

#    google-chrome = let
#        google-chrome_updated = pkgs.google-chrome.override {
#          commandLineArgs = "--enable-native-gpu-memory-buffers";
#          chromium = {
#            upstream-info = (callPackage ./chromium-upstream-info/update.nix {}).getChannel "stable";
#          };
#        };
#        inherit (pkgs) gtk3;
#        inherit (pkgs.lib) makeLibraryPath makeSearchPathOutput makeBinPath;
#      in
#        google-chrome_updated.overrideDerivation (attr:{
#          rpath = makeLibraryPath [gtk3] + ":" + makeSearchPathOutput "lib" "lib64" [gtk3]
#            + attr.rpath + ":" ;
#          binpath = makeBinPath [gtk3] + ":" + attr.binpath;
#        });
#

#    vimb-unwrapped = pkgs.vimb-unwrapped.override {
#       webkit = pkgs.webkitgtk.overrideDerivation (attr:{
#         configureFlags =
#         ["--with-gtk=2.0"]; });
#    };

    racket = pkgs.racket.overrideDerivation (attr: rec {
      LD_LIBRARY_PATH = attr.LD_LIBRARY_PATH+":${pkgs.libedit}/lib";
      postInstall = ''
        for p in $(ls $out/bin/) ; do
          wrapProgram $out/bin/$p --set LD_LIBRARY_PATH "${LD_LIBRARY_PATH}";
        done
      '';
    });

    my-python = pkgs.python3.withPackages (
      pypkgs: with pypkgs; [
        jupyter numpy scipy matplotlib ]);

    my-ghc = pkgs.haskellPackages.ghcWithPackages ( hs: with hs; [
      hscolour
      ghc-mod
    ]);
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
