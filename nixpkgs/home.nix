{ pkgs, ... }:
let
  emacsCommand = emacs: "TERM=xterm-direct ${emacs}/bin/emacsclient -nw";
in rec {
  home = {
    packages = (with pkgs; [
      cabal2nix
      loc
      vimpc
      webtorrent_desktop
      niv
      browsh
      magic-wormhole
      appimage-run
      ghcid
      (ghc.withPackages (hp: with hp; [ haskell-language-server ]))
      git
      git-lfs
      vimHugeX st xmobar
      cabal-install
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
      (pkgs.callPackage (import (builtins.fetchTarball {
        name = "mach-nix-src";
        url = "https://github.com/DavHau/mach-nix/archive/31b21203a1350bff7c541e9dfdd4e07f76d874be.tar.gz";
        sha256 = "0przsgmbbcnnqdff7n43zv5girix83ky4mjlxq7m2ksr3wyj2va2";
      })) { }).mach-nix
    ];

    sessionPath = [
      "$HOME/.emacs.d/bin"
      "$HOME/mutable_node_modules/bin"
    ];

    sessionVariables = {
      EDITOR = "vim";
    };

  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (import (builtins.fetchTarball {
        url = https://github.com/nix-community/emacs-overlay/archive/13fbae4d83ec6ef6f4b72e01bc48b65e74f5a103.tar.gz;
        sha256 = "05yzzyxls46vvmjnv2jdzcrrb8jzqr6zmfv6hhg6qihj9qsq6a4a";
      }))
    ];
  };

  imports = [
    # (let
    #   declCachixRev = "1986455ab3e55804458bf6e7d2a5f5b8a68defce";
    #   declCachix = builtins.fetchTarball {
    #     url = "https://github.com/jonascarpay/declarative-cachix/archive/${declCachixRev}.tar.gz";
    #     sha256 = "0y7zi5pgc9raawh4ll3dww61cqq7rafki757f6njq9k08zkks62j";
    #   };
    # in import "${declCachix}/home-manager.nix")
  ];

  caches = {
    cachix = [
      { name = "nix-community"; sha256 = "00lpx4znr4dd0cc4w4q8fl97bdp7q19z1d3p50hcfxy26jz5g21g"; }
    ];

    extraCaches = [
      {
        url = "https://hydra.iohk.io";
        key = "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ";
      }
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
        # enableFlakes = true;
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
    mpd.enable = false;
    emacs = {
      enable = true;
      client.enable = true;
    };
  };
}
