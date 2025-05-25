{

  description = "flake for machines";

  inputs = {
    nixpkgs_22_05.url = github:nixos/nixpkgs/nixos-22.05;
    nixpkgs_22_11.url = github:nixos/nixpkgs/nixos-22.11;
    nixpkgs_23_05.url = github:nixos/nixpkgs/nixos-23.05;
    nixpkgs_23_11.url = github:nixos/nixpkgs/nixos-23.11;
    nixpkgs_24_11.url = github:nixos/nixpkgs/nixos-24.11;
    nixpkgs_25_05.url = github:nixos/nixpkgs/nixos-25.05;
    flake-utils.url = github:numtide/flake-utils;
    deploy-rs.url = github:serokell/deploy-rs;
    microvm.url = github:astro/microvm.nix;

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

  };

  outputs = inputs@{ self, flake-utils, ... }:
    let

      coati-bebop-hosts = {
        "cafe"            = "100.107.189.30";
        "aero15"          = "100.127.249.88";
        "galaxy-a90-5g"   = "100.70.106.129";
        "ix"              = "100.96.164.28";
        "laptop-aa6mgb61" = "100.77.135.92";
        "p1gen3"          = "100.94.44.110";
        "tres-cantos"     = "100.86.176.106";
        "x230"            = "100.105.240.29";
      };

    in

      {
        inherit inputs self;

        nixosConfigurations =
          let

            mkNixosSystem =  host-name: { nixpkgs, stateVersion ? "22.05", system ? "x86_64-linux", modules ? [] }:
              nixpkgs.lib.nixosSystem {
                inherit system;
                modules = [

                  { config._module.args = { inherit stateVersion coati-bebop-hosts; }; }

                  { environment.etc."nix/channels/nixpkgs".source = nixpkgs.outPath; }

                  ({pkgs, ...}:{
                    imports = [ ];
                    nixpkgs.overlays = [ (next: prev: { foomatic_filters = next.foomatic-filters; }) ];
                    environment.systemPackages = [ pkgs.libxcrypt ];
                  })

                  inputs.microvm.nixosModules.host

                  ./common

                  (./. + "/${host-name}/configuration.nix")

                ] ++ modules;
              };

          in
            __mapAttrs mkNixosSystem {

              x230 = {
                nixpkgs = inputs.nixpkgs_25_05;
                stateVersion = "22.11";
              };

              cafe = {
                nixpkgs = inputs.nixpkgs_22_11;
                stateVersion = "22.11";
              };

              p1gen3 = {
                nixpkgs = inputs.nixpkgs_24_11;
                stateVersion = "22.11";
                modules = [
                  inputs.chaotic.nixosModules.nyx-cache
                  inputs.chaotic.nixosModules.nyx-overlay
                  inputs.chaotic.nixosModules.nyx-registry
                ];
              };

              aero15.nixpkgs = inputs.nixpkgs_22_11;

              tres-cantos.nixpkgs = inputs.nixpkgs_22_11;

            };

      }

      //

        {

          deploy.nodes =
            __mapAttrs (n: v:
              let
                inherit (v.config.nixpkgs.localSystem) system;
                inherit (inputs.deploy-rs.lib.${system}) activate;
              in
                {
                  hostname = "${n}.coati-bebop.ts.net";
                  sshOpts = [ "-A" ];
                  profiles."system" = {
                    user = "root";
                    path = let
                    in activate.nixos v;
                  };
                }) self.nixosConfigurations;

          checks =
            __mapAttrs
              (system: deploy-lib: deploy-lib.deployChecks self.deploy)
              inputs.deploy-rs.lib;

        }

      //

      flake-utils.lib.eachSystem ["x86_64-linux"] (system:
        let
          pkgs = import inputs.nixpkgs_24_11 { inherit system; };
          inherit (inputs.deploy-rs.packages.${system}) deploy-rs;
        in
          {
            packages = {
              local-deploy = pkgs.writeShellScriptBin "local-deploy" ''
                  HOSTNAME=`hostname`
                  echo "***************************************************"
                  echo "$ sudo nixos-rebuild switch --flake \".#$HOSTNAME\""
                  echo "***************************************************"
                  NIX_SSHOPTS="-A" nixos-rebuild switch --flake ".#$HOSTNAME" --print-build-logs --target-host "$HOSTNAME" --use-remote-sudo
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

