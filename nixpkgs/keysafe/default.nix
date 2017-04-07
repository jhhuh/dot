let
  config = rec {
    allowBroken = true;
    packageOverrides = pkgs:  rec {
      haskellPackages = pkgs.haskellPackages.override {
        overrides = self: super: with pkgs.haskell.lib; rec {
          project = self.callPackage ./default.nix {};
          polynomial = overrideCabal super.polynomial (drv: {
            patches = [ (pkgs.fetchpatch {
              url = "https://github.com/mokus0/polynomial/pull/9.patch";
              sha256 = "0vqv1palzb89vbxi7c26d8lw74g8k9fz606ky6bv3pr3y0sv7x0w";})
            ];
          });
          dice-entropy-conduit = overrideCabal super.dice-entropy-conduit (drv: {
            patchPhase = ''
              sed -i -e "s/quickcheck2/quickcheck2, bytestring, conduit, entropy, transformers/" dice-entropy-conduit.cabal 
            '';
          });
          secret-sharing = overrideCabal super.secret-sharing (drv: {
            patchPhase = ''
              sed -i -e "s/LANGUAGE/LANGUAGE DataKinds,/" src/Crypto/SecretSharing/Internal.hs
              sed -i -e "s/quickcheck2/quickcheck2, bytestring, dice-entropy-conduit, finite-field, binary, vector, polynomial/" secret-sharing.cabal 
            '';
          });
          argon2 = overrideCabal super.argon2 (drv: {
            patchPhase = ''
              sed -i -e "s/<4\.9/<4.10/" argon2.cabal
            '';
            doCheck = false;
          });
        };
      };
    };
  };

  pkgs = import <nixpkgs> { inherit config; system = "x86_64-linux"; };

in
  pkgs.haskellPackages // {}
