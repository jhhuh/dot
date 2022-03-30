{ pkgs, lib, inputs, ... }:
let
  emacsCommand = emacs: "TERM=xterm-direct ${emacs}/bin/emacsclient -nw";
in rec {
  home = {
    packages = (with pkgs; [
      qemu
      xclip
      steam-run
      patchelf
      overmind
      mplayer
      google-drive-ocamlfuse
      mosh
      pass
      jq
      koreader
      (with python3Packages; toPythonApplication (
        clvm-tools.overridePythonAttrs (old: {
          propagatedBuildInputs = old.propagatedBuildInputs ++ [setuptools];})))
      linux-manual
      scheme-manpages
      nixos-shell
      dasht
      man-pages
      man-pages-posix
      binutils
      gh
      darcs
      asciinema
      termtosvg
      pandoc
      nix-template
      chia
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
    ];

    sessionPath = [
      "$HOME/.emacs.d/bin"
      "$HOME/mutable_node_modules/bin"
    ];

    sessionVariables = {
      EDITOR = "vim";
    };

    file = {
      home-manager.source = inputs.home-manager;
      nixpkgs.source = inputs.nixpkgs;
    };

  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [];
  };

  nix.registry = {
    nixpkgs.flake = inputs.nixpkgs;
  };

  imports = [ ];

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
    keychain = {
      enable = true;
      extraFlags = [ "-Q" ];
      keys = [ "id_ed25519" ];
    };
    gpg.enable = true;
    tmux = {
      enable = true;
      prefix = "C-j";
      keyMode = "vi";
      sensibleOnTop = true;
      extraConfig = ''
        bind-key ^u copy-mode
        bind-key j new-window
        
        bind-key '"' split-window -c '#{pane_current_path}' 
        bind-key '%' split-window -h -c '#{pane_current_path}' 
        
        set-option -g status-right "[#(acpi --battery | grep -oE '(Discharging|Charging|Unknown), [0-9.]+%')] #{=21:pane_title} %H:%M:%S %d-%b-%y"
        
        set-option -g status-interval 5
        set-option -g automatic-rename on
        set-option -g automatic-rename-format '#{b:pane_current_path}'
        
        set -s escape-time 0
      '';
    };

    man.generateCaches = false;

    git = {
      enable = true;
      userEmail = "jhhuh.note@gmail.com";
      userName = "Ji-Haeng Huh";
      extraConfig = {
        init.defaultBranch = "master";
      };
      package = pkgs.gitFull;
    };

    alacritty.enable = true;
    home-manager = {
      enable = true;
    };

    bash = {
      enable = true;

      shellAliases = {
        vi = emacsCommand programs.emacs.package;
        nix-repl = "nix repl '<nixpkgs>'";
        nix-which = "function __nix-which() { readlink $(which $1); }; __nix-which";
        nix-unpack-from = "function __nix-unpack-from() { nix-shell $1 -A $2 --run unpackPhase; }; __nix-unpack-from";
        nix-unpack = "nix-unpack-from '<nixpkgs>'";
        nix-where-from = "function __nix-where-from() { nix-build $1 -A $2 --no-out-link; }; __nix-where-from";
        nix-where = "nix-where-from '<nixpkgs>'";
        nix-show-tree = "function __nix-show-tree() { nix-shell -p tree --run 'tree $(nix-where $1)'; }; __nix-show-tree";
        nix-visit = "function __nix-visit() { pushd $(nix-where $1); }; __nix-visit";
        nix-X-help-in-Y = "function __nix-X-help-in-Y() { $(nix-where w3m)/bin/w3m $1/share/doc/$2; }; __nix-X-help-in-Y";
        nix-help = "nix-X-help-in-Y $(nix-where nix.doc) nix/manual/index.html";
        nixpkgs-help = "nix-X-help-in-Y $(nix-build --no-out-link '<nixpkgs/doc>') nixpkgs/manual.html";

        nixos-help = "nix-X-help-in-Y $(nix-build '<nixpkgs/nixos/release.nix>' --arg supportedSystems '[ \"x86_64-linux\" ]' -A manual --no-out-link) nixos/index.html";

        nix-outpath = "nix-build --no-out-link '<nixpkgs>' -A";
        nix-position = "function __nix-position() { nix-instantiate '<nixpkgs>' --eval -A $1.meta.position; }; __nix-position";

        nix-build--no-out-link = "nix-build --no-out-link";
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
      package = pkgs.emacsGcc;
      extraPackages = epkgs: with epkgs; [vterm pdf-tools];
    };
  };

  services = {
    gpg-agent.enable = true;
    mpd.enable = false;
    emacs = {
      enable = true;
      client.enable = true;
    };
  };

  manual.html.enable = true;

  dconf.settings =
    let
      mkTuple = lib.hm.gvariant.mkTuple;
    in
    {
      "org/gnome/desktop/input-sources" = {
        per-window = false;
        sources = [(mkTuple ["xkb" "kr"])];
        xkb-options = ["ctrl:swapcaps" "lv3:ralt_switch"];
      };

      "org/gnome/desktop/peripherals/keyboard" = {
        repeat = true;
        delay = 250;
        repeat-interval = 20;
      };

      "org/gnome/desktop/peripherals/touchpad" = {
        two-finger-scrolling-enabled = true;
      };

      "org/gnome/desktop/privacy" = {
        disable-microphone = false;
      };

      "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-type = "nothing";
      };
    };
}

