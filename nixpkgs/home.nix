{ pkgs, ... }:
let
  emacsCommand = emacs: "TERM=xterm-direct ${emacs}/bin/emacsclient -nw";
in rec {
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/13fbae4d83ec6ef6f4b72e01bc48b65e74f5a103.tar.gz;
      sha256 = "05yzzyxls46vvmjnv2jdzcrrb8jzqr6zmfv6hhg6qihj9qsq6a4a";
    }))
  ];

  imports = [
    (let
      declCachixRev = "1986455ab3e55804458bf6e7d2a5f5b8a68defce";
      declCachix = builtins.fetchTarball
        "https://github.com/jonascarpay/declarative-cachix/archive/${declCachixRev}.tar.gz";
    in import "${declCachix}/home-manager.nix")
  ];

  caches = {
    cachix = [
      "nix-community"
    ];

    extraCaches = [
      #{
      #  url = "https://hydra.iohk.io";
      #  key = "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ";
      #}
    ];
  };

  home = {
    sessionPath = [
      "$HOME/.emacs.d/bin"
    ];

    sessionVariables = {
      EDITOR = "vim";
    };

    packages = (with pkgs; [
      appimage-run
      git
      git-lfs
      vimHugeX st xmobar
      cabal-install
      ghc
      ws
      wget
      acpi
      powertop
      ripgrep
      sqlite
      wordnet
      sbcl
      htop tree
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
    ]) ++
    [
      (pkgs.callPackage (import (builtins.fetchTarball {
        name = "comma-src";
        url = "https://github.com/shopify/comma/archive/4a62ec17e20ce0e738a8e5126b4298a73903b468.tar.gz";
        sha256 = "0n5a3rnv9qnnsrl76kpi6dmaxmwj1mpdd2g0b4n1wfimqfaz6gi1";
      })) { })
    ];
  };

  programs = {
    git = {
      enable = true;
      extraConfig = {
        init.defaultBranch = "master";
      };
    };

    alacritty.enable = true;
    home-manager = {
      enable = true;
    };

    bash = {
      enable = true;
      shellAliases = {
        "nix-repl" = "nix repl '<nixpkgs>'";
        "vi" = emacsCommand programs.emacs.package;
      };
      bashrcExtra = ''
        # git-prompt
        source ${pkgs.git}/share/git/contrib/completion/git-prompt.sh

        get_sha() {
            git rev-parse --short HEAD 2>/dev/null
        }
        
        GIT_PS1_SHOWDIRTYSTATE=1
        GIT_PS1_SHOWSTASHSTATE=1
        GIT_PS1_SHOWUNTRACKEDFILES=1
        GIT_PS1_DESCRIBE_STYLE="branch"
        GIT_PS1_SHOWUPSTREAM="auto git"
        PROMPT_COLOR="1;31m"
        let $UID && PROMPT_COLOR="1;32m"
        #PS1='\n\[\033[$PROMPT_COLOR\][\u@\h \W]\[\033[0m\]$(__git_ps1 " (%s)")\n\$ '
        PROMPT_COMMAND='__git_ps1 "'
        PROMPT_COMMAND+='\[\033[00;36m\]\u\[\033[00m\]@'
        PROMPT_COMMAND+='\[\033[00;32m\]\h\[\033[00m\]:'
        PROMPT_COMMAND+='\[\033[00;34m\]\w\[\033[00m\]'
        PROMPT_COMMAND+='" "'
        PROMPT_COMMAND+='\n'
        PROMPT_COMMAND+='\[\033[01;35m\]$(is_in_nixshell "(" ")")\[\033[00m\]$ '
        PROMPT_COMMAND+='" "(%s)"'
        
        is_in_nixshell() {
            if [ $IN_NIX_SHELL ]
            then
                echo "$1$name$2"
            elif [[ "$PATH" =~ "/nix/store/" ]]
            then
                echo "$PATH" | sed -e "s#.*/nix/store/[^-]*-\([^/:]*\).*#$1\1$2#"
            fi
        }
      '';
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
        theme = "ansi";
      };
    };

    firefox.enable = true;

    emacs = {
      enable = true;
      package = pkgs.emacs; #Gcc;
      extraPackages = epkgs: with epkgs; [vterm pdf-tools];
    };
  };

  services = {
    emacs = {
      enable = true;
      client.enable = true;
    };
  };
}
