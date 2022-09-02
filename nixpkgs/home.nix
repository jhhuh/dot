{ config, pkgs, lib, inputs, ... }:

let

  emacsCommand = emacs: "TERM=xterm-direct ${emacs}/bin/emacsclient -nw";

  toggle-touchpad = pkgs.writeScriptBin "toggle_touchpad.sh"
       ''
         #!{bash}/bin/bash
         
         if [ $(gsettings get org.gnome.desktop.peripherals.touchpad send-events) == "'enabled'" ]; then
           echo "Switching off"
           gsettings set org.gnome.desktop.peripherals.touchpad send-events disabled
else     
           echo "Switching on"
         gsettings set org.gnome.desktop.peripherals.touchpad send-events enabled
         fi
       '';

  clvm-tools = with pkgs.python3Packages;
    toPythonApplication (
      clvm-tools.overridePythonAttrs (old: {
        propagatedBuildInputs = old.propagatedBuildInputs ++ [setuptools];}));

  nix-L = {runCommand, nix, makeWrapper}:
    runCommand "nix" { buildInputs = [pkgs.makeWrapper]; } ''
      mkdir $out
      ln -s ${pkgs.nix}/* $out/
      rm -rf $out/bin
      mkdir $out/bin
      ln -s ${pkgs.nix}/bin/* $out/bin/
      wrapProgram $out/bin/nix --add-flags "-L"
    '';

  farbfeld = {stdenv, fetchzip, xorg, SDL, ghostscript, sqlite}:
    stdenv.mkDerivation {
      name = "farbfeld";

      src = fetchzip {
        url = "http://zzo38computer.org/prog/farbfeld.zip";
        sha256 = "sha256-guxTyZmi6w4jrGp+sdLddAur+PJUV3sUoyXC0lmC1LA=";
        stripRoot = false;
      };

      buildInputs = [ xorg.libX11 SDL ghostscript sqlite ];

      buildPhase = ''
        mkdir ./bin

        ls *.c \
          | xargs grep --no-filename "^gcc " \
          | sed -e "s#~/bin#./bin#" \
          | xargs -I {} sh -c "echo -e \"echo -e {}\n{}\"" \
          > ./build.sh

        substituteInPlace ./build.sh \
          --replace sqlite3.o ${sqlite.out}/lib/libsqlite3.so.0 \
          --replace /usr/lib/libgs.so.9 ${ghostscript}/lib/libgs.so.9

        gcc -c ./lodepng.c

        source ./build.sh

      '';

      installPhase = ''
        mkdir -p $out/bin
        cp ./bin/* $out/bin
      '';
    };


in {

  nixpkgs.overlays = [
    #(import ./overlays/01-stackage-overlay.nix)
    #(import ./overlays/02-myHaskellPackages.nix)
    (import ./overlays/03-myPackages.nix)
    (import ./overlays/04-myEnvs.nix)
    (import ./overlays/05-prefer-remote-fetch.nix)
  ];

  home = {
    packages = (with pkgs; [
      (callPackage farbfeld {})
      arandr
      (callPackage nix-L {})
      # For xmonad setup
      st
      xst
      ranger
      kotatogram-desktop
      scrcpy
      zathura
      xmobar
      pavucontrol
      compton

      #
      pixiecore
      xpra
      sshuttle
      kmscube
      libdrm
      kmscon
      mpv
      toggle-touchpad
      cntr
      #qemu
      xclip
      steam-run
      patchelf
      overmind
      mplayer
      google-drive-ocamlfuse
      niv
      nodePackages.node2nix
      mosh
      pass
      jq
      koreader
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
      #chia
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
      #myVim
      cabal-install
      # ws
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

  nix.registry = {
    nixpkgs.flake = inputs.nixpkgs;
  };

  imports = [ ];

  caches = {
    cachix = [
      {
        name = "nix-community";
        sha256 = "1955r436fs102ny80wfzy99d4253bh2i1vv1x4d4sh0zx2ssmhrk";
      }
    ];

    extraCaches = [
      {
        url = "https://hydra.iohk.io";
        key = "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ";
      }
    ];
  };

  programs = {

    doom-emacs = {
      enable = false;
      emacsPackage = pkgs.emacsNativeComp;
      doomPrivateDir = ../doom.d;
      emacsPackagesOverlay = self: super: {
        # fixes https://github.com/vlaci/nix-doom-emacs/issues/394
        gitignore-mode = self.git-modes;
        gitconfig-mode = self.git-modes;
      };
    };

    vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        base16-vim
        vim-airline
      ];
      extraConfig = ''
        set nobackup noswapfile
      '';
    };

    vscode = {
      enable = false;
      package = pkgs.vscode-fhs;
    };

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

    home-manager.enable = true;

    bash = {
      enable = true;

      shellAliases = {
        vi = emacsCommand config.programs.emacs.package;
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

        watch-direnv = "while true; do _direnv_hook; sleep 1; done";
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
      package = pkgs.emacsNativeComp;
      extraPackages = epkgs: with epkgs; [vterm pdf-tools];
    };

  };

  services = {
    syncthing = {
      enable = true;
      tray = false;
    };
    keynav.enable = true;
    gpg-agent.enable = true;
    mpd.enable = false;
    emacs = {
      enable = false;
      client.enable = true;
    };
  };

  manual.html.enable = true;

  #dconf.settings =
  #  let
  #    mkTuple = lib.hm.gvariant.mkTuple;
  #  in
  #  {
  #    "org/gnome/desktop/input-sources" = {
  #      per-window = false;
  #      sources = [(mkTuple ["xkb" "kr"])];
  #      xkb-options = ["ctrl:swapcaps" "lv3:ralt_switch"];
  #    };

  #    "org/gnome/desktop/peripherals/keyboard" = {
  #      repeat = true;
  #      delay = 250;
  #      repeat-interval = 20;
  #    };

  #    "org/gnome/desktop/peripherals/touchpad" = {
  #      two-finger-scrolling-enabled = true;
  #    };

  #    "org/gnome/desktop/privacy" = {
  #      disable-microphone = false;
  #    };

  #    "org/gnome/settings-daemon/plugins/power" = {
  #      sleep-inactive-ac-type = "nothing";
  #    };
  #  };
}

