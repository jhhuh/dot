{
  description = "flake for machines";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    utils.url = github:numtide/flake-utils;
    deploy-rs.url = github:serokell/deploy-rs;
  };

  outputs = inputs@{ self, nixpkgs, utils, deploy-rs }: {
    nixosConfigurations = {
      tres-cantos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./tres-cantos/configuration.nix ];
      };
    };

    deploy.nodes = {
      tres-cantos = {
        hostname = "localhost";
        sshOpts = [ "-A" ];
        profiles."system" = {
          user = "root";
          path = deploy-rs.lib."x86_64-linux".activate.nixos self.nixosConfigurations.tres-cantos;
        };
      };
    };
  } // utils.lib.eachSystem ["x86_64-linux"] (system:
  let
    pkgs = import nixpkgs { inherit system; };
  in
  {

    devShell = pkgs.mkShell {
      buildInputs = [
        deploy-rs.defaultPackage."${system}"
      ];
    };

    checks = deploy-rs.lib."${system}".deployChecks self.deploy;

  });

}

