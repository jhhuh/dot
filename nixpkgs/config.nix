let
  nixpkgs = import <nixpkgs> {};
  inherit (nixpkgs) callPackage stdenv;
  lts-6_12 = nixpkgs.haskell.packages.lts-6_12;
in
  {
    allowUnfree = true;
    allowBroken = true;
    packageOverrides = pkgs: rec {

      tpacpi-bat = callPackage ./tpacpi-bat {};

      yasr = callPackage ./yasr {};

      freetts = pkgs.freetts.overrideDerivation (attr:{ buildInputs = [ pkgs.jdk ]; }) ;

      eflite = callPackage ./eflite {};

      bluez-alsa = callPackage ./bluez-alsa/HEAD.nix {
              automake = pkgs.automake.overrideDerivation (attr:{ patches = [ ./automake115x.patch ]; });
      };

      my-haskell.ghc7103 = pkgs.haskell.packages.ghc7103.override {
        overrides = self: super: {
          dice-entropy-conduit = pkgs.haskell.lib.dontCheck super.dice-entropy-conduit;
          scientific = pkgs.haskell.lib.dontCheck super.scientific;
          secret-sharing = pkgs.haskell.lib.appendConfigureFlag super.secret-sharing "--ghc-options=-XDataKinds";
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
      
      keysafe = my-haskell.ghc7103.keysafe;
    
    };
  }
