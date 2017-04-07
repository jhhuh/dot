let
  config = rec {
    allowUnfree = true;
    packageOverrides = pkgs:  rec {
      haskellPackages = haskellPackagesWith pkgs;
    };
  };
  haskellPackagesWith = pkgs: pkgs.haskellPackages.override {
    overrides = self: super: with pkgs.haskell.lib; rec {
      project = self.callPackage ./default.nix {};
    };
  };

pkgs = import <nixpkgs> { inherit config; system = "x86_64-linux"; };

in
  pkgs.haskellPackages // { inherit (pkgs.haskellPackages) project; }
