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
    ++ [ (haskell.lib.justStaticExecutables haskellPackages.pandoc) ]
    ++ [ imagemagick_light lsof p7zip paperkey tree unzip ]
    ++ [ watch xz patchelf sshfs-fuse nixops zip ];
};

personalToolsEnv = pkgs.buildEnv {
  name = "personalToolsEnv";
  paths = [ aria2 gimp haskellPackages.git-annex iw ]
#    ++ [ electrum ]
    ++ [ libressl mplayer pavucontrol ranger reptyr ]
    ++ [ rfkill sl sshuttle tigervnc ]
    ++ [ usbutils vimpc xorg.xwd youtube-dl zathura ]
    ++ [ pythonPackages.pygments ];
};

haskellDevEnv = pkgs.buildEnv {
  name = "haskellDevEnv";
  paths = [ haskellPackages.cabal-install cabal2nix ];
};

pythonDevEnv = let
  myPython = python36.withPackages (p: with p; [
    jupyter
    scipy numpy pandas matplotlib
    qrcode ]);
in
  myPython;

myHaskellOverrides = self: super:
  with pkgs.haskell.lib; let pkg = self.callPackage; in rec {

  # diagrams-graphviz         = doJailbreak super.diagrams-graphviz;
  # heap			                = dontCheck super.heap;
  # freer-effects      		    = dontCheck super.freer-effects;
  # reroute	       	          = dontCheck super.reroute;
  # superbuffer		            = dontCheck super.superbuffer;

  # extra_1_6_9               = pkg ./extra_1_6_9 {};
  # ghcid_0_7		              = pkg ./ghcid_0_7 {
  #   extra = self.extra_1_6_9;
  # };

};

haskell = super.haskell // { packageOverrides = myHaskellOverrides;};

ghcWithMegaPackagesWithHoogle = haskellPackages.ghcWithHoogle (import ./mega-ghc-package-list.nix);
ghcWithMegaPackages = haskellPackages.ghcWithPackages (import ./mega-ghc-package-list.nix);

ghcEnv = let
  paths = with haskellPackages;
  [ ghcWithMegaPackages
    alex happy
    ghc-core
    hlint
    ghcid
#    ghc-mod
#    hdevtools
    pointfree
    hasktags
#    djinn
    mueval
    lambdabot
    threadscope
    timeplot
#    splot
#    liquidhaskell
    idris
    Agda
    stylish-haskell
  ];
  in
  pkgs.buildEnv {
    name = "ghcEnv";
    inherit paths;
  };

racket = super.racket.overrideAttrs (attr: rec {
  LD_LIBRARY_PATH = attr.LD_LIBRARY_PATH+":${self.libedit}/lib";
  postInstall = ''
    for p in $(ls $out/bin/) ; do
      wrapProgram $out/bin/$p --set LD_LIBRARY_PATH "${LD_LIBRARY_PATH}";
    done
  '';
});

}; # End of packageOverrides

} # End of the nix expression
