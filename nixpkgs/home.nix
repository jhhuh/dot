{ config, pkgs, lib, inputs, ... }:

let

  packages =  (with pkgs; [
    cloudflare-warp
    #(haskell.lib.justStaticExecutables haskellPackages.summoner-tui)
    unzip
    graphviz
    feh
    nix-prefetch
    ffmpeg
    yt-dlp
    libsixel
    w3m
    farbfeld
    farbfeld-utils
    arandr
    st xst

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
    (ghc.withPackages (hp: with hp; [ haskell-language-server graphmod ]))
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

  emacsCommand = emacs: "TERM=st-direct ${emacs}/bin/emacsclient -nw";

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
      wrapProgram $out/bin/nix --inherit-argv0 --add-flags "-L"
    '';

in {

  nixpkgs.overlays = [
    inputs.haskell-nix.overlay
    (import ./overlays/03-myPackages.nix)
    (import ./overlays/04-myEnvs.nix)
    (import ./overlays/05-prefer-remote-fetch.nix)
  ];

  home = {
    inherit packages;

    sessionPath = [
      "$HOME/.emacs.d/bin"
      "$HOME/mutable_node_modules/bin"
    ];

    sessionVariables = {

      EDITOR = "${config.programs.vim.package}/bin/vim";

      NIX_PATH = let
        # HACK: This is to make it work with `nix repl`
        nixpkgs-overlays = pkgs.writeText "overlays-compat.nix" ''
          let
            user = __getEnv "USER";
            this = (import ${inputs.flake-compat} { src = ${./.}; }).defaultNix;
            inputs = this.inputs;
          in [ inputs.haskell-nix.overlay
               (import ${./.}/overlays/03-myPackages.nix)
               (import ${./.}/overlays/04-myEnvs.nix)
               (import ${./.}/overlays/05-prefer-remote-fetch.nix) ]
        '';

       in lib.concatStringsSep ":" [
        "$HOME/.nix-defexpr/channels"
        "nixpkgs=${inputs.nixpkgs.outPath}"
        "nixpkgs-overlays=${nixpkgs-overlays}" # HACK: This is to make it work with `nix repl`
        "nixos-config=/etc/nixos/configuration.nix"
        "/nix/var/nix/profiles/per-user/root/channels"
      ];

    };

    file = {

      home-manager.source = inputs.home-manager;

      nixpkgs.source = inputs.nixpkgs;

      all-cabal-hashes.source = with pkgs; srcOnly {
        name = "all-cabal-hashes";
        src = all-cabal-hashes;
      };

      # haskell-library-srcs.source = let
      #   inherit (pkgs) haskellPackages linkFarm srcOnly;
      #   inherit (pkgs.lib) filterAttrs mapAttrsToList;
      #   all-libs = filterAttrs (_: v: v ? src) haskellPackages;
      # in linkFarm "haskell-library-srcs"
      # (mapAttrsToList (name: drv: {
      #   inherit name;
      #   path = srcOnly { inherit (drv) name src; };
      # })
      # all-libs);
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

    ncmpcpp.enable = true;

    nix-index.enable = false;

    command-not-found.enable = true;

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
      package = pkgs.tmux;
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
        init.defaultBranch = "main";
      };
      package = pkgs.gitFull;
    };

    home-manager.enable = true;

    bash = {
      enable = true;

      shellAliases = {
        vi = emacsCommand config.programs.emacs.package;
        nix-run = ''function __nix-run() { nix run "nixpkgs#$1" "''${@:2}"; }; __nix-run'';
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

        ipython-for-crawl = lib.concatStringsSep " " [
          "nix-shell"
          ''-p "python3.withPackages (p: with p; [ ipython requests beautifulsoup4 ])"''
          "--run ipython"
        ];
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

        MYBASE16THEME_x230="flat"
        MYBASE16THEME_aero15="atelier-dune-light"
        MYBASE16THEME_cafe="rebecca"
        MYBASE16THEME_dasan="irblack"
        MYBASE16THEME_farmer1="irblack"
        MYBASE16THEME_farmer2="irblack"
        #MYBASE16THEME_laptop-aa6mgb61="irblack"
        MYBASE16THEME_mimir="irblack"
        MYBASE16THEME_p1gen3="nord"
        MYBASE16THEME_roekstonen="irblack"
        MYBASE16THEME_zhao="irblack"

        _MYBASE16THEME="MYBASE16THEME_$HOSTNAME"

        export MYBASE16THEME="''${!_MYBASE16THEME}"
         if [ "''${-#*i}" != "$-" ] && [ -n "$PS1" ] && [ -f ${inputs.base16-shell}/scripts/base16-$MYBASE16THEME.sh ]; then
           source ${inputs.base16-shell}/scripts/base16-$MYBASE16THEME.sh
         fi

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

    mpd = {
      enable = true;
      extraConfig = ''
        audio_output {
          type        "pulse"
          name        "MPD"
          # server      "localhost"
        }
      '';
    };

    emacs = {
      enable = true;
      client.enable = true;
    };
  };

  manual.html.enable = true;

}

