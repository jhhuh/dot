let
  nightly = import nightlyPath { config = {}; };
  nixpkgs = import <nixpkgs> { config = {}; };

  inherit (nixpkgs) callPackage stdenv;
  lts-6_12 = nixpkgs.haskell.packages.lts-6_12;

  nightlyPath = builtins.getEnv "HOME" + "/repo/nixpkgs-nightly";
in
  {
    allowUnfree = true;
    allowBroken = true;
    packageOverrides = super: rec {

      # Merged into the nightly version
      yasr = nightly.yasr;

      #      inherit (nightly) eflite yasr tpacpi-bat;

      # WIP
      rustNightly = super.recurseIntoAttrs (nightly.callPackage (nightlyPath+"/pkgs/development/compilers/rust/nightly.nix") {});

      alacritty = callPackage ./alacritty {
        inherit (super.xorg) libXcursor libXxf86vm libXi;
        rustPlatform = super.makeRustPlatform rustNightly;
      };

      # FAILED!!!!
      flite_alsa = super.flite.overrideDerivation (attr:{ 
        configureFlags = "--enable-shared --with-audio=alsa";
        buildInputs = with super; [ pkgconfig alsaLib alsaLib.dev ];
        CPPFLAGS = "-I ${super.alsaLib.dev}/include";
        LDFLAGS = "-L ${super.alsaLib}/lib";
        patches = [ ./flite-1.9.0.patch ];
      }); # enableOSSEmulation should be off. FAILED!

      bluealsa = callPackage ./bluez-alsa/HEAD.nix {
              automake = super.automake.overrideDerivation (attr:{ patches = [ ./automake115x.patch ]; });
      };

      bluealsa_debug = bluealsa.overrideDerivation (attr:{
        configureFlags = attr.configureFlags+" --enable-debug";
      });

      my-haskell.ghc7103 = super.haskell.packages.ghc7103.override {
        overrides = self: super: {
          dice-entropy-conduit = super.haskell.lib.dontCheck super.dice-entropy-conduit;
          scientific = super.haskell.lib.dontCheck super.scientific;
          secret-sharing = super.haskell.lib.appendConfigureFlag super.secret-sharing "--ghc-options=-XDataKinds";
          singletons = super.mkDerivation {
            pname = "singletons";
            version = "2.1";
            sha256 = "0b213bn1zsjv57xz4460jxs0i85xd5i462v00iqzfb5n6sx99cmr";
            doCheck = false;
            libraryHaskellDepends = with super;[
              base containers mtl syb template-haskell th-desugar
            ];
            testHaskellDepends = with super; [
              base Cabal directory filepath process tasty tasty-golden
            ];
            homepage = "http://www.github.com/goldfirere/singletons";
            description = "A framework for generating singleton types";
            license = stdenv.lib.licenses.bsd3;
          };
        };
      };
      
      #keysafe = my-haskell.ghc7103.keysafe;
    
    };
  }
