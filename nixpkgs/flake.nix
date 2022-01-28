{
  description = "A Home Manager flake";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/22.05-pre";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    declarative-cachix.url = "github:jonascarpay/declarative-cachix";
    declarative-cachix.inputs.nixpkgs.follows = "nixpkgs";

    comma.url = github:nix-community/comma;
    comma.flake = false;

  };

  outputs = inputs: {
    inherit inputs;
    homeConfigurations = {
      "jhhuh" = inputs.home-manager.lib.homeManagerConfiguration rec {
        system = "x86_64-linux";
        homeDirectory = "/home/jhhuh";
        username = "jhhuh";
        configuration.imports = [
          inputs.declarative-cachix.homeManagerModules.declarative-cachix-experimental
          ./home.nix
          ({pkgs, ...}: { home.packages = [(pkgs.callPackage inputs.comma { nix = pkgs.nix_2_3; })]; })
        ];
      };
    };
  };
}
