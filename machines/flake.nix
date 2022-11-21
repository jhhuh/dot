{

  description = "flake for machines";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-22.05;
    flake-utils.url = github:numtide/flake-utils;
    deploy-rs.url = github:serokell/deploy-rs;
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:

  {
    inherit inputs self;

    nixosConfigurations = {

      x230 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./x230/configuration.nix ./common ];
      };

      aero15 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./aero15/configuration.nix ./common  ];
      };

      p1gen3 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./p1gen3/configuration.nix ./common  ];
      };

      cafe = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./cafe/configuration.nix ./common  ];
      };

      tres-cantos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./tres-cantos/configuration.nix ./common  ];
      };

    };
  }

  //

  (let
    inherit (builtins) mapAttrs;
    inherit (inputs) deploy-rs;
    inherit (deploy-rs.lib.x86_64-linux) activate deployChecks;
  in
  {

    deploy.nodes =
      mapAttrs (n: v: 
        {
          hostname = "${n}.coati-bebop.ts.net";
          sshOpts = [ "-A" ];
          profiles."system" = {
            user = "root";
            path = activate.nixos v;
          };
        }) self.nixosConfigurations;

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
        sudo nixos-rebuild switch --flake ".#$HOSTNAME" --print-build-logs
      '';
    };

    apps = rec {
      default = local-deploy;
      local-deploy = {
        type = "app";
        program = "${self.packages.${system}.local-deploy}/bin/local-deploy";
      };
    };

    devShells.default = pkgs.mkShell {
      buildInputs = [
        deploy-rs
      ];
    };

  });

}

