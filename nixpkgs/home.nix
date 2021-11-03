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
      bashrcExtra = ''
        # git-prompt
        if [ -f ~/.nix-profile/share/git/contrib/completion/git-prompt.sh ]; then
            source ~/.nix-profile/share/git/contrib/completion/git-prompt.sh
        elif [ -f $(readlink `which git`|xargs dirname)/../share/git/contrib/completion/git-prompt.sh ]; then
            source $(readlink `which git`|xargs dirname)/../share/git/contrib/completion/git-prompt.sh
        fi
        
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

  services = {
    emacs = {
      enable = true;
      client.enable = true;
    };
  };
}
