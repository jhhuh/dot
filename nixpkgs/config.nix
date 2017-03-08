let
  nixpkgs = import <nixpkgs> {};
  inherit (nixpkgs) callPackage stdenv;
  lts-6_12 = nixpkgs.haskell.packages.lts-6_12;
in
  {
    allowUnfree = true;
    allowBroken = true;
    packageOverrides = pkgs: rec {

      cligh = callPackage ./cligh {};

      # FAILED!!!!
      #      flite_alsa = pkgs.flite.overrideDerivation (attr:{ 
      #        configureFlags = "--enable-shared --with-audio=alsa";
      #        buildInputs = [ pkgs.pkgconfig pkgs.alsaLib pkgs.alsaLib.dev ];
      #        CPPFLAGS = "-I ${pkgs.alsaLib.dev}/include";
      #        LDFLAGS = "-L ${pkgs.alsaLib}/lib";
      #      }); # enableOSSEmulation should be off. FAILED!

      eflite = callPackage ./eflite { };

      freetts = pkgs.freetts.overrideDerivation (attr:{ buildInputs = [ pkgs.jdk ]; }) ;

      pyGithub = with pkgs.pythonPackages; buildPythonPackage rec {
        name = "pyGithub-${version}";
        version = "1.32";
        src = pkgs.fetchurl {
          url = "https://github.com/PyGithub/PyGithub/archive/v${version}.tar.gz";
          sha256 = "0gip9ksm0m78wd2rhv4ahdaclw5fqz1f7bpdv8y3zpq7i9crf443";
        };
        propagatedBuildInputs = [ pythonJose ];
        buildInput = [ pkgs.openssl pkgs.pkgconfig ];
        SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"; # necessary for test to succeed
      };

      pythonJose = with pkgs.pythonPackages; buildPythonPackage rec {
        name = "pythonJose-${version}";
        version = "1.3.2";
        src = pkgs.fetchurl {
          url = "https://github.com/mpdavis/python-jose/archive/${version}.tar.gz";
          sha256 = "16mafs565lx7cqz1q625zgn3my4z7pmln8f6993rrip2i02wyk7g";
        };
        propagatedBuildInputs = [ pycrypto future six ecdsa ];
      };

      tpacpi-bat = callPackage ./tpacpi-bat {};

      yasr = callPackage ./yasr {};

      bluealsa = callPackage ./bluez-alsa/HEAD.nix {
              automake = pkgs.automake.overrideDerivation (attr:{ patches = [ ./automake115x.patch ]; });
      };

      bluealsa_debug = bluealsa.overrideDerivation (attr:{
        configureFlags = attr.configureFlags+" --enable-debug";
      });

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
      
      #keysafe = my-haskell.ghc7103.keysafe;
    
    };
  }
