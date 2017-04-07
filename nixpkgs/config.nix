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

    inherit (nightly) yasr tpacpi-bat;
    
    eflite = nightly.eflite.override {
      debug = true;
      flite = nightly.flite.overrideDerivation (attr:{
        nativeBuildInputs = with pkgs; [ pulseaudioFull.dev ];
        configureFlags = attr.configureFlags + " --with-audio=pulseaudio";
        LDFLAGS = "-L ${pkgs.pulseaudioFull}/lib";
      });
    };

    #    eflite = (nightly.eflite.override { debug = true; }).overrideDerivation (attr:{
    #      buildInputs = attr.buildInputs ++ [ nightly.pulseaudioFull ];
    #      configureFlags = "flite_dir=${nightly.flite} --with-audio=pulseaudio --with-vox=cmu_us_kal16";
    #    });

    # WIP
    rustNightly = pkgs.recurseIntoAttrs (nightly.callPackage (nightlyPath+"/pkgs/development/compilers/rust/nightly.nix") {});

    alacritty = callPackage ./alacritty {
      inherit (pkgs.xorg) libXcursor libXxf86vm libXi;
      rustPlatform = pkgs.makeRustPlatform rustNightly;
    };

    # FAILED!!!!
    flite_alsa = pkgs.flite.overrideDerivation (attr:{ 
      configureFlags = "--enable-shared --with-audio=alsa";
      buildInputs = with pkgs; [ pkgconfig alsaLib alsaLib.dev ];
      CPPFLAGS = "-I ${pkgs.alsaLib.dev}/include";
      LDFLAGS = "-L ${pkgs.alsaLib}/lib";
    }); # enableOSSEmulation should be off. FAILED!

    bluealsa = callPackage ./bluez-alsa/HEAD.nix {
      automake = pkgs.automake.overrideDerivation (attr:{ patches = [ ./automake115x.patch ]; });
    };

    bluealsa_debug = bluealsa.overrideDerivation (attr:{
      configureFlags = attr.configureFlags+" --enable-debug";
    });

    haskellPackages7103 = pkgs.haskell.packages.ghc7103.override {
      overrides = self: super: rec { 
        gtk2hs-buildtools = super.gtk2hs-buildtools.override {
          Cabal = self.Cabal_1_24_2_0;
        };
      };
    };
  };
}
