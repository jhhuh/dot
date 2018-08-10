{ pkgs }: {

allowUnfree = true;

packageOverrides = super: let self = super.pkgs; in with self; rec {

brainworkshop = self.callPackage ./brainworkshop {};

ataripp = self.callPackage ./atari++ {};

BlueALSA = self.callPackage ./BlueALSA {};

systemToolsEnv = pkgs.buildEnv {
  name = "systemToolsEnv";
  paths = [ file bind inotify-tools gnupg gparted ]
    ++ [ (haskell.lib.justStaticExecutables haskPkgs.pandoc) ]
    ++ [ imagemagick_light lsof p7zip paperkey tree unzip ]
    ++ [ watch xz patchelf sshfs-fuse nixops zip ];
};

personalToolsEnv = pkgs.buildEnv {
  name = "personalToolsEnv";
  paths = [ aria2 electrum gimp haskPkgs.git-annex iw ]
    ++ [ libressl mplayer pavucontrol ranger reptyr ]
    ++ [ rfkill sl sshuttle telegram-cli tdesktop tigervnc ]
    ++ [ usbutils vimpc xorg.xwd youtube-dl zathura firefox ];
};

haskellDevEnv = pkgs.buildEnv {
  name = "haskellDevEnv";
  paths = [ haskPkgs.cabal-install_1_24_0_2 cabal2nix ];
};

pythonDevEnv = let
  myPython = python36.withPackages (p: with p; [
    jupyter
    scipy numpy pandas matplotlib
    qrcode ]);
in
  myPython;

myHaskellOverrides = libProf: self: super:
  with pkgs.haskell.lib; let pkg = self.callPackage; in rec {

  diagrams-graphviz         = doJailbreak super.diagrams-graphviz;
  heap			    = dontCheck super.heap;
  freer-effects		    = dontCheck super.freer-effects;

  # ghcWithHoogle = selectFrom:
  #   let
  #     packages = selectFrom self;
  #     hoogle = pkg ./hoogle-local.nix { inherit packages; };
  #   in self.ghc.withPackages # Actually, it is ghcWithPackages (so confusing)
  #     (_: packages ++ [ hoogle ]);
 
  mkDerivation = args: super.mkDerivation (args // {
    enableLibraryProfiling = libProf;
    enableExecutableProfiling = false;
  });
  
};

haskell822Packages = super.haskell.packages.ghc822.override {
  overrides = myHaskellOverrides false;
};

profiledHaskell822Packages = super.haskell.packages.ghc822.override {
  overrides = myHaskellOverrides true;
};

haskPkgs = haskellPackages;
haskellPackages = haskell822Packages;

ghcWithAll = haskPkgs.ghcWithHoogle (import ./hoogle-package-list.nix);

ghc82env = let
  paths = with haskPkgs;
  [ ghcWithAll
    alex happy
    ghc-core
    hlint
#    ghc-mod
    hdevtools
    pointfree
    hasktags
    djinn
    mueval
    lambdabot
    threadscope
    timeplot
#    splot
    #    liquidhaskell
    idris
# Agda
    stylish-haskell
  ];
  in
  pkgs.buildEnv {
    name = "ghc82env";
    inherit paths;
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

} # End of the nix expression
