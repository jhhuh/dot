{ config, pkgs, lib, inputs, system, hostname, stateVersion, username, homeDirectory, ... }:

let
 
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
    #
    # blockchain
    #
    electrum
   
    #
    # Messenger
    #
    signal-desktop
    discordo

    # DB
    postgresql
    sqlite

    # Screenshot
    scrot
    gnome.gnome-screenshot

    # Nix-{related,specific}
    patchelf
    nix-prefetch
    nodePackages.node2nix
    comma

    # Emulation
    qemu
    dosbox-x

    # Compilers/interpreters-related
    sbcl
    cabal-install
    ghcid
    cabal2nix
    nodejs

    # Version controll system
    gh
    git-lfs

    # Document creation/reading
    pandoc
    texlive.combined.scheme-full
    koreader

    # Manual
    linux-manual
    man-pages
    man-pages-posix
    scheme-manpages
    dasht
    zeal

    # Packages that my `xmonad.hs` depends on
    picom            # Transparency
    feh
    farbfeld
    farbfeld-utils   # BG img
    xmobar                        # just xmobar
    (st-flexipatch.override { patchNames = [ "SIXEL" ]; }) # suckless terminals
    xst                           # suckless terminals
    pavucontrol                   # Volume control
    zathura                       # zathura
    scrcpy                        # Android mirroring
    ranger                        # TUI File manager

    # Network
    sshuttle
    xpra
    x2x

    # Video
    ffmpeg
    mplayer

    # CLI tools
    fx
    google-drive-ocamlfuse
    pass
    mosh
    asciinema
    termtosvg
    magic-wormhole
    graphviz
    yt-dlp
    wget
    libsixel
    w3m
    pciutils
    acpi
    unzip
    binutils
    jq
    loc
    tree
    ripgrep
    fd
    htop
    parallel
    xdotool
    xclip
    arandr
    powertop
    git-annex

    # Misc.
    nerdfonts

    poetry
    passphrase2pgp

    haskellPackages.implicit-hie
    ghc
    stack

    git-crypt

    wordnet

    (pkgs.callPackage ./pkgs/vastai {})

    distrobox
  ];


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

  EDITOR = "${config.programs.neovim.package}/bin/nvim";

  shellAliases = {
    nix-callPackage = "nix-callPackage-from ./.";
    nix-callPackage-from = ''function __nix-callPackage-from() { nix build -L --impure --expr "(import <nixpkgs> {}).callPackage $1 {}"; }; __nix-callPackage-from'';

    nix-run = ''function __nix-run() { nix run "nixpkgs#$1" "''${@:2}"; }; __nix-run'';
    nix-repl = "nix repl '<nixpkgs>'";
    nix-which = "function __nix-which() { readlink $(which $1); }; __nix-which";
    nix-unpack-from = "function __nix-unpack-from() { nix-shell $1 -A $2 --run unpackPhase; }; __nix-unpack-from";
    nix-unpack = "nix-unpack-from '<nixpkgs>'";
    nix-where-from = "function __nix-where-from() { nix-build $1 -A $2 --no-out-link; }; __nix-where-from";
    nix-where = "nix-where-from '<nixpkgs>'";
    nix-show-tree = "function __nix-show-tree() { nix-shell -p tree --run 'tree $(nix-where $1)'; }; __nix-show-tree";

    nix-visit = "function __nix-visit() { pushd $(nix-where $1); }; __nix-visit";
    nix-visit-src = ''function __nix-visit-src() { pushd $(nix build -L --impure --expr "with (import <nixpkgs> {}); srcOnly $1" --no-link --print-out-paths); }; __nix-visit-src'';

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

    ec = emacsCommand config.programs.emacs.package;
    vi = emacsCommand config.programs.emacs.package;

    start-emacs    = "systemctl start  --user emacs.service && systemctl status --user emacs.service";
    restart-emacs  = "systemctl restart  --user emacs.service";
    status-emacs   = "systemctl status --user emacs.service";
    stop-emacs     = "systemctl stop   --user emacs.service";

    cabal-unpack = ''function __cabal-unpack() { mkdir -p ~/hackage-unpack && pushd ~/hackage-unpack && cd $(cabal unpack $1 2>&1 | grep -o "$1-[.0-9]*" || echo $PWD); }; __cabal-unpack'';
    init-haskell = "nix flake init --template git+ssh://git@github.com/asgard-labs/flake-template --refresh";
  };


  bashrcExtra = ''
        MYBASE16THEME_x230="flat"
        MYBASE16THEME_aero15="atelier-dune-light"
        MYBASE16THEME_cafe="rebecca"
        MYBASE16THEME_dasan="irblack"
        MYBASE16THEME_farmer1="irblack"
        MYBASE16THEME_farmer2="irblack"
        #MYBASE16THEME_laptop-aa6mgb61="irblack"
        MYBASE16THEME_mimir="irblack"
        MYBASE16THEME_p1gen3="dracula" # "one-light" # "nord"
        MYBASE16THEME_roekstonen="irblack"
        MYBASE16THEME_zhao="irblack"

        _MYBASE16THEME="MYBASE16THEME_$HOSTNAME"

        export MYBASE16THEME="''${!_MYBASE16THEME}"
         if [ "''${-#*i}" != "$-" ] && [ -n "$PS1" ] && [ -f ${inputs.base16-shell}/scripts/base16-$MYBASE16THEME.sh ]; then
           source ${inputs.base16-shell}/scripts/base16-$MYBASE16THEME.sh
         fi
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
      neovim        = true;
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
      starship     = true;

    }
    {
      ## 1. Nix-related
      ## 2. Browsers
      ## 3. Editors
      vim.extraConfig = "set nobackup noswapfile";
      vim.plugins = with pkgs.vimPlugins; [
        base16-vim vim-airline ];

      neovim.viAlias = true;
      neovim.vimAlias = true;
      neovim.vimdiffAlias = true;

      emacs.package = pkgs.emacs29;
      emacs.extraPackages = epkgs: with epkgs; [
        all-the-icons
        vterm
        pdf-tools
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
        package = (pkgs.tmux.overrideAttrs (old: {
          postPatch = (old.postPatch or "")
            + ''
              substituteInPlace input.c \
                --replace "#define INPUT_BUF_LIMIT 1048576" "#define INPUT_BUF_LIMIT 10485760"
            '';
        }));
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
          '';
      };

      ## 5. Shell
      bash = {
        inherit shellAliases bashrcExtra;
        inherit (config.home) sessionVariables;
        historyControl = [ "erasedups" "ignoredups" "ignorespace" ];
      };

      starship.enableBashIntegration = true;
      starship.settings = {
        nix_shell = {
          disabled = false;
          impure_msg = "";
          symbol = "";
          format = "[$symbol$state]($style) ";
          heuristic = true;
        };
        shlvl = {
          disabled = false;
          symbol = "λ ";
        };
        haskell.symbol = " ";
      };

    };

  services = enable-with-config
    {
      gpg-agent = true;
      emacs     = false; # isDesktop;
    }
    {
      gpg-agent.pinentryPackage = pkgs.pinentry-gnome3; 
      emacs.client.enable = true;
    };

  home = {
    inherit stateVersion username homeDirectory packages;
    sessionVariables = { inherit EDITOR NIX_PATH; };
    sessionPath = [
      "$HOME/bin"
      "$HOME/.config/emacs/bin"
      "$HOME/mutable_node_modules/bin"
      "$HOME/.cargo/bin"
    ];
    file = __mapAttrs (_: source: { inherit source; }) {
      inherit (inputs) home-manager nixpkgs;
      home-pkgs = pkgs.linkFarmFromDrvs "home-pkgs" config.home.packages;
    };
  };

  nix.package = pkgs.nix;
  nix.registry.nixpkgs.flake = inputs.nixpkgs;

  manual.html.enable = true;
  fonts.fontconfig.enable = true;

}

