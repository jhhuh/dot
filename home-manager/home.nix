{ config, pkgs, lib, inputs, system, hostname, stateVersion, username, homeDirectory, ... }:

let

#  nix-tools = ;

  nix-init = inputs.nix-init.packages.${system}.default;

  emacsCommand = emacs: "TERM=st-direct ${emacs}/bin/emacsclient -nw";

  # Combinator separating `enable` flags from the rest
  # making it easy to identify the enabled programs/services.
  enable-with-config = enable-attrs: config-attrs:
    let
      config-list = map
        (name:
          if enable-attrs.${name}
          then {
            inherit name;
            value = { enable = enable-attrs.${name}; }
                    // (config-attrs.${name} or {});
          }
          else { inherit name; value = {}; })
        (__attrNames enable-attrs);
    in __listToAttrs config-list;


  isServer = __elem hostname [ "dasan" ];

  isDesktop = __elem hostname [ "aero15" "x230" "p1gen3" "cafe" ];

  packages = if isDesktop then packages-for-desktop else packages-for-server;

  packages-for-server = with pkgs; [
    inputs.devenv.packages.${system}.devenv
    unzip
    binutils
    jq loc tree ripgrep
    htop
    parallel
    mosh
    magic-wormhole
    wget
    w3m
    pciutils acpi
    patchelf nix-prefetch
    nixos-shell comma
    git-annex
    poetry
    nix-init
  ];

  packages-for-desktop = with pkgs; [
    espeak-ng
    # Messenger
    #kotatogram-desktop-with-webkit
    keybase-gui
    # DB
    postgresql sqlite
    # Screenshot
    scrot gnome.gnome-screenshot
    # Nix-{related,specific}
    patchelf nix-prefetch
    inputs.devenv.packages.${system}.devenv
    nix-template
    appimage-run steam-run
    nixos-shell comma
    # Emulation
    qemu
    # Compilers/interpreters-related
    sbcl
    nodePackages.node2nix
    cabal-install ghcid cabal2nix
    # Version controll system
    gh git-lfs
    darcs
    # Document creation/reading
    texlive.combined.scheme-full pandoc
    koreader
    # Manual
    linux-manual man-pages man-pages-posix
    dasht scheme-manpages
    # Packages that my `xmonad.hs` depends on
    compton                       # Transparency
    feh farbfeld farbfeld-utils   # BG img
    xmobar                        # just xmobar
    st xst                        # suckless terminals
    pavucontrol                   # Volume control
    zathura tabbed tabbed-zathura # For {,tabbed-}zathura
    scrcpy                        # Android mirroring
    ranger                        # TUI File manager
    # Network
    cloudflare-warp sshuttle
    xpra x2x
    # Video
    ffmpeg mplayer
    # Personal scripts
    toggle-touchpad
    # CLI tools
    fx
    google-drive-ocamlfuse
    pass
    mosh
    asciinema termtosvg
    magic-wormhole
    graphviz
    yt-dlp wget
    libsixel w3m
    pciutils acpi
    unzip
    binutils
    jq loc tree ripgrep
    htop
    parallel
    xdotool arandr xclip
    # Misc.
    nerdfonts

    poetry
    passphrase2pgp
    powertop
    signal-desktop
    #(pkgs.callPackage ./pkgs/ytui-music {})
    #cachix
    nix-init

    mermaid-cli
    zeal
  ];

  tabbed-zathura = pkgs.writeScriptBin "tabbed-zathura.sh" ''
      #! /bin/sh

      XID_FILE="$XDG_RUNTIME_DIR/zathura.xid"
      ${pkgs.xorg.xprop}/bin/xprop -id "$(< $XID_FILE)" &> /dev/null \
        || rm $XID_FILE &> /dev/null

      if [ -f $XID_FILE ];
      then
          ${pkgs.zathura}/bin/zathura -e $(< $XID_FILE) $@
      else
          XID=$(${pkgs.tabbed}/bin/tabbed -c -n tabbed-zathura -d ${pkgs.zathura}/bin/zathura $@ -e)
          echo $XID > $XID_FILE
          # ${pkgs.zathura}/bin/zathura -e $XID $@
      fi
    '';

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

  nixpkgs-overlays-compat-nix = pkgs.writeText "nixpkgs-overlays-compat.nix" ''
      let
        this = (import ${inputs.flake-compat} { src = ${./.}; }).defaultNix;
      in
        this.overlays
    '';

  NIX_PATH = lib.concatStringsSep ":" [
    "$HOME/.nix-defexpr/channels"
    "nixpkgs=${inputs.nixpkgs.outPath}"
    "nixpkgs-overlays=${nixpkgs-overlays-compat-nix}"
    "nixos-config=/etc/nixos/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

  EDITOR = "${config.programs.vim.package}/bin/vim";

  shellAliases = {
    nix-callPackage = "nix-callPackage-from ./.";
    nix-callPackage-from = ''function __nix-callPackage-from() { nix build -L --impure --expr "(import <nixpkgs> {}).callPackage $1 {}"; }; __nix-callPackage-from'';
    nix-visit-src = ''function __nix-visit-src() { nix build -L --impure --expr "with (import <nixpkgs> {}); srcOnly $1"; }; __nix-visit-src'';
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
    nix-outpath = "nix-build --no-out-link '<nixpkgs>' -A";
    nix-position = "function __nix-position() { nix-instantiate '<nixpkgs>' --eval -A $1.meta.position; }; __nix-position";
    nix-build--no-out-link = "nix-build --no-out-link";

    nixpkgs-help = "nix-X-help-in-Y $(nix-build --no-out-link '<nixpkgs/doc>') nixpkgs/manual.html";

    nixos-help = "nix-X-help-in-Y $(nix-build '<nixpkgs/nixos/release.nix>' --arg supportedSystems '[ \"x86_64-linux\" ]' -A manual --no-out-link) nixos/index.html";

    watch-direnv = "while true; do _direnv_hook; sleep 1; done";

    my-ip = "curl -s https://wtfismyip.com/json | ${pkgs.jq}/bin/jq";

    ipython-for-crawl = lib.concatStringsSep " " [
      "nix-shell"
      ''-p "python3.withPackages (p: with p; [ ipython requests beautifulsoup4 ])"''
      "--run ipython"
    ];

    vi = emacsCommand config.programs.emacs.package;

    start-emacs    = "systemctl start  --user emacs.service && systemctl status --user emacs.service";
    restart-emacs  = "systemctl restart  --user emacs.service";
    status-emacs   = "systemctl status --user emacs.service";
    stop-emacs     = "systemctl stop   --user emacs.service";

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
        MYBASE16THEME_p1gen3="one-light" # "nord"
        MYBASE16THEME_roekstonen="irblack"
        MYBASE16THEME_zhao="irblack"

        _MYBASE16THEME="MYBASE16THEME_$HOSTNAME"

        export MYBASE16THEME="''${!_MYBASE16THEME}"
         if [ "''${-#*i}" != "$-" ] && [ -n "$PS1" ] && [ -f ${inputs.base16-shell}/scripts/base16-$MYBASE16THEME.sh ]; then
           source ${inputs.base16-shell}/scripts/base16-$MYBASE16THEME.sh
         fi

        ${pkgs.macchina}/bin/macchina
      '';
in

{

  # Programs
  programs = enable-with-config
    {
      ## 1. Nix-related
      nix-index     = true;
      home-manager  = true;
      ## 2.Browsers
      firefox       = isDesktop;
      brave         = isDesktop;
      google-chrome = isDesktop;
      ## 3. Editors
      vim           = true;
      emacs         = isDesktop;
      vscode        = isDesktop;
      ## 4. CLI tools
      bat           = true;
      direnv        = true;
      keychain      = true;
      git           = true;
      tmux          = true;
      gpg           = true;
      fzf           = true;
      ## 5. Shell
      bash          = true;
    }
    {
      ## 1. Nix-related
      ## 2. Browsers
      ## 3. Editors
      vim.extraConfig = "set nobackup noswapfile";
      vim.plugins = with pkgs.vimPlugins; [
        base16-vim vim-airline ];

      emacs.extraPackages = epkgs: with epkgs; [
        all-the-icons
        vterm
        pdf-tools
        emacspeak
        greader
      ];

      vscode.extensions = with pkgs.vscode-extensions; [
        ms-toolsai.jupyter ms-toolsai.jupyter-keymap vscodevim.vim ];

      ## 4. CLI tools
      bat.config.theme = "ansi";

      direnv.enableBashIntegration = true;
      direnv.nix-direnv.enable = true;

      keychain.extraFlags = [ "-q" ];
      keychain.keys = [ "id_ed25519" ];

      git.userEmail = "jhhuh.note@gmail.com";
      git.userName = "Ji-Haeng Huh";
      git.extraConfig.init.defaultBranch = "master";
      git.package = pkgs.gitFull;

      tmux = {
        package = pkgs.tmux;
        prefix = "C-j";
        keyMode = "vi";
        sensibleOnTop = true;

        terminal = "tmux-256color";
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

            set -ag terminal-overrides ",xterm-256color:RGB"
          '';
      };

      ## 5. Shell
      bash = { inherit shellAliases bashrcExtra; };

    };

  # Services
  services = enable-with-config
    {
      keybase   = isDesktop;
      kbfs      = isDesktop;
      syncthing = isDesktop;
      gpg-agent = true;
      emacs     = isDesktop;
    }
    {
      syncthing.tray = false;
      emacs.client.enable = true;
    };

  # Home
  home = {
    inherit stateVersion username homeDirectory packages;
    sessionVariables = { inherit EDITOR NIX_PATH; };
    sessionPath = [ "$HOME/.emacs.d/bin" "$HOME/mutable_node_modules/bin" ];
    file = __mapAttrs (_: source: { inherit source; }) {
      inherit (inputs) home-manager nixpkgs;
      home-pkgs = pkgs.linkFarmFromDrvs "home-pkgs" config.home.packages;
    };
  };

  # Nix-related
  nix.package = pkgs.nix;
  nix.registry.nixpkgs.flake = inputs.nixpkgs;

  caches.cachix = let
    hashes.nix-community = "sha256:0m6kb0a0m3pr6bbzqz54x37h5ri121sraj1idfmsrr6prknc7q3x";
  in map (name: { inherit name; sha256 = hashes.${name}; }) (__attrNames hashes);

  caches.extraCaches = [
    { url = "https://nixcache.reflex-frp.org"; key = "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="; }
  ];

  # Miscs.
  manual.html.enable = true;
  fonts.fontconfig.enable = true;

}

