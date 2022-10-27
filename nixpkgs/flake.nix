{
  description = "A Home Manager flake";

  inputs = {

    nixpkgs.url = github:nixos/nixpkgs/nixos-22.05;

    home-manager.url = github:nix-community/home-manager/release-22.05;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    declarative-cachix.url = github:jonascarpay/declarative-cachix;
    declarative-cachix.inputs.nixpkgs.follows = "nixpkgs";

    emacs-overlay.url = github:nix-community/emacs-overlay;

    nix-doom-emacs.url = github:nix-community/nix-doom-emacs;
    nix-doom-emacs.inputs.nixpkgs.follows = "nixpkgs";
    nix-doom-emacs.inputs.emacs-overlay.follows = "emacs-overlay";

    comma.url = github:nix-community/comma;
    comma.flake = false;

    x86-manpages-nix.url = github:blitz/x86-manpages-nix;
    x86-manpages-nix.flake = false;

    base16-shell.url = github:chriskempson/base16-shell;
    base16-shell.flake = false;

  };

  outputs = inputs:
    let
      system = "x86_64-linux";
      config = { allowUnfree = true; };
      module-declarative-cachix = inputs.declarative-cachix.homeManagerModules.declarative-cachix-experimental;
      module-nix-doom-emacs = inputs.nix-doom-emacs.hmModule;
    in
      {
        inherit inputs;
        homeConfigurations = {
          jhhuh = inputs.home-manager.lib.homeManagerConfiguration {
            configuration = ./home.nix;
            inherit system;
            homeDirectory = "/home/jhhuh";
            username = "jhhuh";
            extraModules = [
              module-declarative-cachix
              module-nix-doom-emacs
            ];
            extraSpecialArgs = {
              inherit inputs;
            };
            pkgs = import inputs.nixpkgs { inherit system config; };
            stateVersion = "22.05";
          };
        };
      };
}
