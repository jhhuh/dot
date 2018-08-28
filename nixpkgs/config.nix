{ pkgs }: {

allowUnfree = true;

packageOverrides = super: let self = super.pkgs; in with self; rec {

firefox-devedition-bin-unwrapped = super.firefox-devedition-bin-unwrapped.override {
  generated = import ./firefox-devedition-update/devedition_sources.nix; };

vban = self.callPackage ./vban {};

duktape = self.callPackage (fetchurl {
  url = "https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/development/interpreters/duktape/default.nix";
  sha256 = "0q9nf5dsl7dlblgwzdji3gbhlcg3d0lixwzvypybkavzflrlkx79";
  }) {};

scrcpy = self.callPackage (fetchurl {
  url = "https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/misc/scrcpy/default.nix";
  sha256 = "1g90mn67d9dlybhynx9nwx50zvgqzrrqrgwpm80pzy08ln2rprnq";
  }) {
    stdenv = self.stdenv
             // { lib = self.stdenv.lib
                        // { maintainers = self.stdenv.lib.maintainers
                                           // { deltaevo = null; }; }; };
    platformTools = self.androidenv.platformTools;
  };

  
edbrowse = self.callPackage (fetchurl {
  url = "https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/applications/editors/edbrowse/default.nix";
  sha256 = "0nvh78dz21kbkmb6vgl452640ci6b271rrzq0rg61pdxf249nsqb";
  }) {};

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
  heap			                = dontCheck super.heap;
  freer-effects		    = dontCheck super.freer-effects;

  extra_1_6_9         = pkg ./extra_1_6_9 {};
  ghcid_0_7           = pkg ./ghcid_0_7 { extra = self.extra_1_6_9; };

  easyplot            = super.easyplot.overrideDerivation (attr:{
    patchPhase = ''mv Setup.lhs Setup.hs'';
  });
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
    ghcid_0_7
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

}; # End of packageOverrides

} # End of the nix expression
