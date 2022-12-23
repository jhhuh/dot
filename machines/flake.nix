{

  description = "flake for machines";

  inputs = {
    nixpkgs_22_05.url = github:nixos/nixpkgs/nixos-22.05;
    nixpkgs_22_11.url = github:nixos/nixpkgs/nixos-22.11;
    flake-utils.url = github:numtide/flake-utils;
    deploy-rs.url = github:serokell/deploy-rs;
  };

  outputs = inputs@{ self, flake-utils, ... }:

  {
    inherit inputs self;

    nixosConfigurations =
      let

      mkNixosSystem =  host-name: { nixpkgs, stateVersion ? "22.05", system ? "x86_64-linux" }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ (./. + "/${host-name}/configuration.nix") ./common ];
          extraArgs = {
            inherit stateVersion;
          };
        };

      in
        __mapAttrs mkNixosSystem {

          x230 = {
            nixpkgs = inputs.nixpkgs_22_11;
            stateVersion = "22.11";
          };

          cafe = {
            nixpkgs = inputs.nixpkgs_22_11;
            stateVersion = "22.11";
          };

          p1gen3 = {
            nixpkgs = inputs.nixpkgs_22_11;
            stateVersion = "22.11";
          };

          aero15.nixpkgs = inputs.nixpkgs_22_05;

          tres-cantos.nixpkgs = inputs.nixpkgs_22_05;

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
    pkgs = import inputs.nixpkgs_22_11 { inherit system; };
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

