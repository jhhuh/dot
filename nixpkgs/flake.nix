{
  description = "A Home Manager flake";

  inputs = {

    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;

    home-manager.url = github:nix-community/home-manager;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    declarative-cachix.url = github:jonascarpay/declarative-cachix;
    declarative-cachix.inputs.nixpkgs.follows = "nixpkgs";

    emacs-overlay.url = github:nix-community/emacs-overlay;

    comma.url = github:nix-community/comma;
    comma.flake = false;

    x86-manpages-nix.url = github:blitz/x86-manpages-nix;
    x86-manpages-nix.flake = false;
  };

  outputs = inputs:
    let
      declarative-cachix-module = inputs.declarative-cachix.homeManagerModules.declarative-cachix-experimental;
      emacs-overlay-module = {pkgs, ...}: {
        nixpkgs.overlays = [inputs.emacs-overlay.overlay];
      };
      home-packages-module = {pkgs, ...}: {
        home.packages = [
          (pkgs.callPackage inputs.comma { nix = pkgs.nix_2_3; })
          (pkgs.callPackage inputs.x86-manpages-nix {
            pkgs = pkgs // { stdenv = pkgs.stdenv // { lib = pkgs.lib; }; };
            sources = null;
            nixpkgs = null; })
        ];};
    in
      {
        inherit inputs;
        homeConfigurations = {
          jhhuh = inputs.home-manager.lib.homeManagerConfiguration rec {
            system = "x86_64-linux";
            homeDirectory = "/home/jhhuh";
            username = "jhhuh";
            configuration.imports = [
              declarative-cachix-module
              emacs-overlay-module
              home-pacakges-module
              ./home.nix
            ];
          };
        };
      };
}
