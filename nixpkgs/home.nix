{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    }))
  ];

  home = {
    sessionPath = [
      "$HOME/.emacs.d/bin"
    ];

    sessionVariables = {
      EDITOR = "vim";
    };

    packages = (with pkgs; [
      ws
      wget
      acpi
      powertop
      ripgrep
      sqlite
      wordnet
      sbcl
      bat htop tree
      nextcloud-client
      kotatogram-desktop gnome.gnome-tweaks mattermost-desktop
      google-chrome
      gnome.dconf-editor
      xdotool
      gjs
      gnome.zenity
      gnome-network-displays
      gnomecast
    ]) ++
    (with pkgs.gnomeExtensions; [
      appindicator
      soft-brightness
      e-ink-mode
      bitcoin-markets
      (ddterm.overrideAttrs (attrs: {
        nativeBuildInputs = attrs.nativeBuildInputs or [] ++ [
          pkgs.wrapGAppsHook
        ];
        buildInputs = attrs.buildInputs or [] ++ (with pkgs; [
          glib
          gtk3
          pango
          vte
        ]);
      }))
      gsconnect
      unite
    ]);
  };

  programs = {
    home-manager = {
      enable = true;
    };

    bash = {
      enable = true;
      shellAliases = {
        "nix-repl" = "nix repl '<nixpkgs>'";
      };
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv = {
        enable = true;
        enableFlakes = true;
      };
    };

    bat = {
      enable = true;
      config = {
        theme = "GitHub";
      };
    };

    firefox.enable = true;

    emacs = {
      enable = true;
      package = pkgs.emacsGcc;
      extraPackages = epkgs: with epkgs; [vterm pdf-tools];
    };
  };
}
