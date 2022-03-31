{

  description = "flake for machines";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    flake-utils.url = github:numtide/flake-utils;
    deploy-rs.url = github:serokell/deploy-rs;
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:

  {
    inherit inputs self;

    nixosConfigurations = {

      aero15 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./aero15/configuration.nix ];
      };

      tres-cantos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./tres-cantos/configuration.nix ];
      };

    };
  }

  //

  (let
    inherit (inputs) deploy-rs;
    inherit (deploy-rs.lib.x86_64-linux) activate deployChecks;
  in
  {

    deploy.nodes =
      {

        aero15 = {
          hostname = "aero15.jhhuh-korea.gmail.com.beta.tailscale.net";
          sshOpts = [ "-A" ];
          profiles."system" = {
            user = "root";
            path = activate.nixos self.nixosConfigurations.aero15;
          };
        };

        tres-cantos = {
          hostname = "tres-cantos.jhhuh-korea.gmail.com.beta.tailscale.net";
          sshOpts = [ "-A" ];
          profiles."system" = {
            user = "root";
            path = activate.nixos self.nixosConfigurations.tres-cantos;
          };
        };

      };

    checks = deployChecks self.deploy;

  })

  //

  flake-utils.lib.eachSystem ["x86_64-linux"] (system:
  let
    pkgs = import nixpkgs { inherit system; };
    inherit (inputs.deploy-rs.packages.${system}) deploy-rs;
  in
  {
    packages = {
      local-deploy = pkgs.writeScriptBin "local-deploy" ''
        HOSTNAME=`hostname`
        echo "***************************************************"
        echo "$ sudo nixos-rebuild switch --flake \".#$HOSTNAME\""
        echo "***************************************************"
        sudo nixos-rebuild switch --flake ".#$HOSTNAME"
      '';
    };

    apps = {
      local-deploy = {
        type = "app";
        program = "${self.packages.${system}.local-deploy}/bin/local-deploy";
      };
    };

    defaultApp = self.apps.${system}.local-deploy;

    devShell = pkgs.mkShell {
      buildInputs = [
        deploy-rs
      ];
    };

  });

}

