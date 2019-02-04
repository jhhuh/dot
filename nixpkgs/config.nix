{ pkgs }: {

allowUnfree = true;

packageOverrides = super: let self = super.pkgs; in with self; rec {

xmonadFull = self.lib.lowPrio (
  super.xmonad-with-packages.override {
    packages = hs: with hs;[ xmonad-contrib xmonad-extras ]; });

tinyemu = self.callPackage ./tinyemu {};

x230_icc = self.fetchurl rec {
         name = "lp125wf2-spb2.icc";
         url = with meta; "https://github.com/${owner}/${repo}/blob/${rev}/${name}?raw=true";
         sha256 = "18lidz1k98344i5z6m7mf8sl12syzvrzrlpbjm7hmhhyv96a44rc";
         meta = {
              owner = "soleblaze";
              repo = "icc";
              rev = "77775bfdeb08a73ba74db6457610be2859b7ce6f";
         };};

xhk = self.callPackage ./xhk {};

firefox-devedition-bin-unwrapped = super.firefox-devedition-bin-unwrapped.override {
  generated = import ./firefox-devedition-update/devedition_sources.nix; };

vban = self.callPackage ./vban {};

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
  paths = [ aria2 gimp iw ] # haskellPackages.git-annex ]
#    ++ [ electrum ]
    ++ [ libressl pavucontrol ranger reptyr ]
    ++ [ rfkill sl sshuttle tigervnc ]
    ++ [ usbutils vimpc xorg.xwd youtube-dl ]; #zathura ]
#    ++ [ pythonPackages.pygments ];
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

#stackage = snapshot: let stackageOverlays = import (fetchTarball {
#                                url = "https://stackage.serokell.io/drczwlyf6mi0ilh3kgv01wxwjfgvq14b-stackage/default.nix.tar.gz";
#                                sha256 = "1bwlbxx6np0jfl6z9gkmmcq22crm0pa07a8zrwhz5gkal64y6jpz"; });
#  in
#    (stackageOverlays.${snapshot} self super).haskell.packages.${snapshot};
#
#hackage-mirror = (stackage "lts-6.35").hackage-mirror;

myHaskellOverrides = self: super:
  with pkgs.haskell.lib; let pkg = self.callPackage; in rec {
    lambdabot = super.lambdabot.overrideScope (self: super: {
      hoogle = self.callHackage "hoogle" "5.0.17.3" {};
    });
#  servant-docs = doJailbreak super.servant-docs;
  
};

haskell = super.haskell // { packageOverrides = myHaskellOverrides;};

ghcWithMegaPackagesWithHoogle = haskellPackages.ghcWithHoogle (import ./mega-ghc-package-list.nix);
ghcWithMegaPackages = haskellPackages.ghcWithPackages (import ./mega-ghc-package-list.nix);

ghcEnv = let
  paths = with haskellPackages;
  [ ghcWithMegaPackagesWithHoogle
    alex happy
    ghc-core
#    hlint
    ghcid
#    ghc-mod
#    hdevtools
    pointfree
    hasktags
#    djinn
    mueval
#    lambdabot
    threadscope
    timeplot
#    splot
#    liquidhaskell
#    idris
#    Agda
    stylish-haskell
    xmonadFull
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
