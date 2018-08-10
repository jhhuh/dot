{ pkgs }: {

allowUnfree = true;

packageOverrides = super: let self = super.pkgs; in with self; rec {

nixopsUnstable = super.nixopsUnstable.overrideDerivation (attr: {
  patchPhase = ''
             substituteInPlace nix/eval-machine-info.nix \
             --replace 'system.nixosVersion' 'system.nixos.version'
             substituteInPlace nix/ec2.nix \
             --replace 'system.nixosVersion' 'system.nixos.version'
  '';});

brainworkshop = self.callPackage ./brainworkshop {};

ataripp = self.callPackage ./atari++ {};

BlueALSA = self.callPackage ./BlueALSA {};

systemToolsEnv = pkgs.buildEnv {
  name = "systemToolsEnv";
  paths = [
    aspell
    file
    bind
    inotify-tools
    gnupg
    gparted
    (haskell.lib.justStaticExecutables haskPkgs.pandoc)
    imagemagick_light
    lsof
    p7zip
    paperkey
    tree
    unzip
    watch
    xz
    patchelf
    sshfs-fuse
    nixops
    nix-repl
    zip
  ];
};

personalToolsEnv = pkgs.buildEnv {
  name = "personalToolsEnv";
  paths = [
    aria2
    electrum
    gimp
    haskPkgs.git-annex
    iw
    libressl
    mplayer
    pavucontrol
    ranger
    reptyr
    rfkill
    sl
    sshuttle
    telegram-cli
    tdesktop
    tigervnc
    usbutils
    vimpc
    xorg.xwd
    youtube-dl
    zathura
    firefox
  ];
};

#haskellDevEnv = pkgs.buildEnv {
#  name = "haskellDevEnv";
#  paths = [
#    haskPkgs.cabal-install_1_24_0_2
#    cabal2nix
#  ];
#};
#
#pythonDevEnv = let
#  myPython = python36.withPackages (p: with p; [
#    jupyter
#    scipy numpy pandas matplotlib
#    qrcode ]);
#in
#  myPython;
#
## It was for debugging
## myHoogle = self.haskPkgs.ghcWithHoogle (import ./hoogle-package-list.nix);
#
#myHaskellPackages = libProf: self: super:
#  with pkgs.haskell.lib; let pkg = self.callPackage; in rec {
#
#  ### Hackage overrides
#
#  argon2                   = dontCheck (doJailbreak super.argon2);
#  blaze-builder-enumerator = doJailbreak super.blaze-builder-enumerator;
#  compressed               = doJailbreak super.compressed;
#  dice-entropy-conduit     = dontCheck super.dice-entropy-conduit;
#  finite-field_0_8_0       = pkg ./finite-field_0_8_0 {};
#  pipes-binary             = doJailbreak super.pipes-binary;
#  pipes-zlib               = doJailbreak (dontCheck super.pipes-zlib);
#  polynomial               = doJailbreak (dontCheck super.polynomial);
#  time-recurrence          = doJailbreak super.time-recurrence;
#  aeson_0_11_3_0           = doJailbreak super.aeson_0_11_3_0;
#  cubicbezier              = dontCheck super.cubicbezier;
#
##  cabal-install_1_24_0_2 = pkg ./cabal-install-1.24.0.2 {};
#
#  servant                  = super.servant // { noHoogle = true; };
#
#  secret-sharing           = (dontHaddock (dontCheck super.secret-sharing)).override {
#    finite-field = self.finite-field_0_8_0;
#  };
##  template-haskell_2_12_0_0= super.template-haskell_2_12_0_0.override {
##    ghc-boot-th = self.ghc-boot-th_8_2_1;
##  };
#  
##  algebraic-classes = (doJailbreak super.algebraic-classes).override {
##    template-haskell = self.template-haskell_2_12_0_0;
##  };
#  
##  free-functors = let
##    template-haskell = self.template-haskell_2_12_0_0;
##    tagged = self.tagged.override { inherit template-haskell; };
##    distributive = (dontCheck self.distributive).override { inherit tagged; };
##    comonad = (dontCheck self.comonad).override { inherit tagged distributive; };
##    bifunctors = (dontCheck self.bifunctors).override {
##      inherit template-haskell tagged comonad;
##    };
##    profunctors = self.profunctors.override {
##      inherit tagged comonad distributive bifunctors;
##    };
##   in super.free-functors.override {
##       inherit template-haskell bifunctors comonad profunctors;
##      };
#
#  ghcWithHoogle = selectFrom:
#    let
#      packages = selectFrom self;
#      hoogle = pkg ./hoogle-local.nix { inherit packages; };
#    in self.ghc.withPackages # Actually, it is ghcWithPackages (so confusing)
#      (_: packages ++ [ hoogle ]);
# 
#  mkDerivation = args: super.mkDerivation (args // {
#    enableLibraryProfiling = libProf;
#    enableExecutableProfiling = false;
#  });
#  
#}; # End of myHaskellPackages
#
#haskell802Packages = super.haskell.packages.ghc802.override {
#  overrides = myHaskellPackages false;
#};
#
#profiledHaskell802Packages = super.haskell.packages.ghc802.override {
#  overrides = myHaskellPackages true;
#};
#
#haskellPackages = haskell802Packages;
#
#haskPkgs = haskellPackages;
#ghcWithAll = haskPkgs.ghcWithHoogle (import ./hoogle-package-list.nix);
#
#_ghc80env = let
#  paths = with haskPkgs;
#  [ ghcWithAll
#    alex happy
#    ghc-core
#    hlint
#    ghc-mod
#    hdevtools
#    pointfree
#    hasktags
#    djinn
#    mueval
#    lambdabot
#    threadscope
#    timeplot
#    splot
#    #    liquidhaskell
#    idris
#    # Agda
#    stylish-haskell
#  ];
#  in
#  pkgs.buildEnv {
#    name = "ghc80env";
#    inherit paths;
#  };
#
#ghc80env = pkgs.stdenv.mkDerivation {
#    name = "ghc80env";
#    buildInputs = [ _ghc80env ];
#    shellHook = ''
#      export NIX_GHC_LIBDIR=${_ghc80env}/lib/ghc-${ghc.version}
#    '';
#  };
#  
##haskell821Packages = super.haskell.packages.ghc821.override {
##  overrides = myHaskellPackages false;
##};
#
#ghc82env = pkgs.buildEnv {
#  name = "ghc82env";
#  paths = with haskell821Packages; [
#    haskell821Packages.ghc
#    alex happy
#  ];
#};

#racket = super.racket.overrideDerivation (attr: rec {
#  LD_LIBRARY_PATH = attr.LD_LIBRARY_PATH+":${self.libedit}/lib";
#  postInstall = ''
#    for p in $(ls $out/bin/) ; do
#      wrapProgram $out/bin/$p --set LD_LIBRARY_PATH "${LD_LIBRARY_PATH}";
#    done
#  '';
#});

}; # End of packageOverrides

} # End of the nix expression
