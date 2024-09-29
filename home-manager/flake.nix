{
  description = "home-manager setup for jhhuh";

  inputs = {

    nixpkgs.url = github:nixos/nixpkgs/nixos-24.05;

    nixpkgs-unstable.url = github:nixos/nixpkgs/nixos-unstable;

    home-manager.url = github:nix-community/home-manager/release-24.05;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    declarative-cachix.url = github:jonascarpay/declarative-cachix;

    nix-init.url = github:nix-community/nix-init;

    emacs-overlay.url = github:nix-community/emacs-overlay;

    doom-emacs.url = github:doomemacs/doomemacs;
    doom-emacs.flake = false;

    x86-manpages-nix.url = github:blitz/x86-manpages-nix;
    x86-manpages-nix.flake = false;

    base16-shell.url = github:chriskempson/base16-shell;
    base16-shell.flake = false;

    haskell-nix.url = github:input-output-hk/haskell.nix;

    flake-compat.url = github:edolstra/flake-compat;
    flake-compat.flake = false;

    devenv.url = github:cachix/devenv;

    haskell-language-server.url = github:haskell/haskell-language-server/2.1.0.0;

  };

  outputs = inputs:
    let
      system = "x86_64-linux";

      config = import ./config.nix;

      overlays = [
        inputs.haskell-nix.overlay
        inputs.emacs-overlay.overlay
        (import ./overlays/02-backports.nix { inherit (inputs) nixpkgs-unstable; inherit system; })
        (import ./overlays/03-myPackages.nix)
        (import ./overlays/04-myEnvs.nix)
        (import ./overlays/05-prefer-remote-fetch.nix)
      ];

      pkgs = import inputs.nixpkgs { inherit system config overlays; };

      module-declarative-cachix = inputs.declarative-cachix.homeManagerModules.declarative-cachix-experimental;

      mkHomeConfiguration = hostname:
        inputs.home-manager.lib.homeManagerConfiguration {

          inherit pkgs;

          modules = [
            ./home.nix
            module-declarative-cachix
          ];

          extraSpecialArgs = {
            inherit inputs hostname system;
            stateVersion = "22.11";
            username = "jhhuh";
            homeDirectory = "/home/jhhuh";
          };
        };

    in

      {

        inherit inputs overlays pkgs;

        homeConfigurations = __listToAttrs
          (map (hostname: {
            name = "jhhuh@${hostname}";
            value = mkHomeConfiguration hostname; })
          [ "aero15" "x230" "p1gen3" "cafe" "dasan" ]);

        apps.x86_64-linux = pkgs.callPackage ./apps {
          scripts.print-env = ''
            env
            echo "*** PWD ***: $PWD"
            echo "*** 0 ***: $0"
          '';
        };

      };

  nixConfig = {

    extra-trusted-public-keys = [
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    ];

    extra-substituters = [
      "https://cache.iog.io"
    ];

  };

}
