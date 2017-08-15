{ pkgs }: {
packageOverrides = super: let self = super.pkgs; in with self; rec {

systemToolsEnv = pkgs.buildEnv {
  name = "systemTools";
  paths = [
    aspell
    file
    gnupg
    (haskell.lib.justStaticExecutables haskPkgs.pandoc)
    imagemagick_light
    p7zip
    paperkey
    tree
    unzip
    watch
    xz
    zip
  ];
};


myHaskellPackages = libProf: self: super:
  with pkgs.haskell.lib; let pkg = self.callPackage; in rec {

  ### Hackage overrides

  # Agda                     = dontHaddock super.Agda;
  # QuickCheck-safe          = doJailbreak super.QuickCheck-safe;
  # bench                    = doJailbreak super.bench;
  blaze-builder-enumerator = doJailbreak super.blaze-builder-enumerator;
  compressed               = doJailbreak super.compressed;
  # dependent-sum-template   = doJailbreak super.dependent-sum-template;
  # newtype-generics         = doJailbreak super.newtype-generics;
  # hasktags                 = doJailbreak super.hasktags;
  # idris                    = doJailbreak super.idris;
  # language-ecmascript      = doJailbreak super.language-ecmascript;
  # machinecell              = doJailbreak super.machinecell;
  # machines                 = doJailbreak super.machines;
  pipes-binary             = doJailbreak super.pipes-binary;
  pipes-zlib               = doJailbreak (dontCheck super.pipes-zlib);
  # pointfree                = doJailbreak super.pointfree;
  # process-extras           = dontCheck super.process-extras;
  # sbv                      = dontCheck (doJailbreak (pkg ~/oss/sbv {}));
  # servant                  = super.servant_0_11;
  # servant-client           = super.servant-client_0_11;
  # servant-docs             = super.servant-docs_0_11;
  # servant-foreign          = super.servant-foreign_0_11;
  # servant-server           = super.servant-server_0_11;

  template-haskell_2_12_0_0= super.template-haskell_2_12_0_0.override {
    ghc-boot-th = self.ghc-boot-th_8_2_1;
  };
  
  time-recurrence          = doJailbreak super.time-recurrence;
  # timeparsers              = dontCheck (pkg ~/oss/timeparsers {});
  # total                    = doJailbreak super.total;
  aeson_0_11_3_0           = doJailbreak super.aeson_0_11_3_0;
  cubicbezier              = dontCheck super.cubicbezier;
  
  algebraic-classes = (doJailbreak super.algebraic-classes).override {
    template-haskell = self.template-haskell_2_12_0_0;
  };
  
  free-functors = let
    template-haskell = self.template-haskell_2_12_0_0;
    tagged = self.tagged.override { inherit template-haskell; };
    distributive = (dontCheck self.distributive).override { inherit tagged; };
    comonad = (dontCheck self.comonad).override { inherit tagged distributive; };
    bifunctors = (dontCheck self.bifunctors).override {
      inherit template-haskell tagged comonad;
    };
    profunctors = self.profunctors.override {
      inherit tagged comonad distributive bifunctors;
    };
  in super.free-functors.override {
       inherit template-haskell bifunctors comonad profunctors;
     };

  
  mkDerivation = args: super.mkDerivation (args // {
    enableLibraryProfiling = libProf;
    enableExecutableProfiling = false;
  });
  
};

haskPkgs = haskell802Packages;
haskellPackages = haskPkgs;

haskell802Packages = super.haskell.packages.ghc802.override {
  overrides = myHaskellPackages false;
};

profiledHaskell802Packages = super.haskell.packages.ghc802.override {
  overrides = myHaskellPackages true;
};

ghc80Env = pkgs.myEnvFun {
  name = "ghc80";
  buildInputs = with haskell802Packages; [
    (ghcWithHoogle (import ./hoogle-package-list.nix))
    alex happy cabal-install
    ghc-core
    hlint
    ghc-mod
    hdevtools
    pointfree
    hasktags
    # hpack
    # c2hsc
    djinn mueval
    lambdabot
    threadscope
    timeplot splot
    liquidhaskell
    idris
    Agda
  ];
};

ghc80ProfEnv = pkgs.myEnvFun {
  name = "ghc80prof";
  buildInputs = with profiledHaskell802Packages; [
    (ghcWithPackages (import ./hoogle-package-list.nix))
    alex happy cabal-install
    ghc-core
  ];
};
haskell821Packages = super.haskell.packages.ghc821.override {
  overrides = myHaskellPackages false;
};
profiledHaskell821Packages = super.haskell.packages.ghc821.override {
  overrides = myHaskellPackages true;
};

ghc82Env = pkgs.myEnvFun {
  name = "ghc82";
  buildInputs = with haskell821Packages; [
    haskell821Packages.ghc
    alex happy # cabal-install
  ];
};

ghc82ProfEnv = pkgs.myEnvFun {
  name = "ghc82prof";
  buildInputs = with profiledHaskell821Packages; [
    profiledHaskell821Packages.ghc
    alex happy # cabal-install
    ghc-core
  ];
};

racket = super.racket.overrideDerivation (attr: rec {
  LD_LIBRARY_PATH = attr.LD_LIBRARY_PATH+":${self.libedit}/lib";
  postInstall = ''
    for p in $(ls $out/bin/) ; do
      wrapProgram $out/bin/$p --set LD_LIBRARY_PATH "${LD_LIBRARY_PATH}";
    done
  '';
  });

}; # End of packageOverrides

}
