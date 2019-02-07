{ pkgs }: {

allowUnfree = true;

packageOverrides = super: let self = super.pkgs; in with self; rec {

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
firefox-devedition-bin-unwrapped = (super.firefox-devedition-bin-unwrapped.overrideAttrs (attr:{
  libPath = self.lib.makeLibraryPath (with self.xorg; [ libXcursor libXi ]) + ":" + attr.libPath;
})).override {
  generated = import ./firefox-devedition-update/devedition_sources.nix;
};

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
  paths = [ aria2 gimp haskellPackages.git-annex iw ]
#    ++ [ electrum ]
    ++ [ libressl mplayer pavucontrol ranger reptyr ]
    ++ [ rfkill sl sshuttle tigervnc ]
    ++ [ usbutils vimpc xorg.xwd youtube-dl ] #zathura ]
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

# stackage = snapshot: let stackageOverlays = import (fetchTarball {
#                                 url = "https://stackage.serokell.io/drczwlyf6mi0ilh3kgv01wxwjfgvq14b-stackage/default.nix.tar.gz";
#                                 sha256 = "1bwlbxx6np0jfl6z9gkmmcq22crm0pa07a8zrwhz5gkal64y6jpz"; });
#   in
#     (stackageOverlays.${snapshot} self super).haskell.packages.${snapshot};

#hackage-mirror-stack = (stackage "lts-6.35").hackage-mirror;

hackage-mirror = with haskell.lib; let
  unpatched = haskell.packages.ghc822.hackage-mirror;
  patched = appendPatch unpatched ./patches/hackage-mirror.patch;
in patched.overrideScope (self: super: {
  conduit = self.conduit_1_2_13_1;
  resourcet = self.resourcet_1_1_11;
  conduit-extra = self.conduit-extra_1_2_3_2;
  streaming-commons = self.callHackage "streaming-commons" "0.1.19" {};
  xml-conduit = self.xml-conduit_1_7_1_2;
  aeson = doJailbreak (self.callHackage "aeson" "1.4.2.0" {});
  aws = doJailbreak (dontCheck (self.callHackage "aws" "0.16" {}));
  conduit-combinators = jailbreakself.callHackage "conduit-combinators" "1.1.2" {};
  http-conduit = self.http-conduit_2_2_4;
  cereal = self.cereal_0_5_8_0;
#  optparse-applicative = doJailbreak (self.callHackage "optparse-applicative" "0.12.1.0" {});
  });

myHaskellOverrides = self: super:
  with pkgs.haskell.lib; let pkg = self.callPackage; in rec {
    heap = dontCheck super.heap;
    doctest-prop = dontCheck super.doctest-prop;
    diagrams-contrib = doJailbreak super.diagrams-contrib;
    diagrams-graphviz = doJailbreak super.diagrams-graphviz;
    diagrams-postscript = doJailbreak super.diagrams-postscript;
    tdigest = doJailbreak super.tdigest;
    servant-docs = doJailbreak super.servant-docs;
    compressed = doJailbreak super.compressed ;
    these = doJailbreak super.these;
    bytestring-show = doJailbreak super.bytestring-show;
    gtk2hs-buildtools = appendPatch super.gtk2hs-buildtools ./patches/gtk2hs-buildtools.patch;
    threadscope = doJailbreak super.threadscope;
    lambdabot = super.lambdabot.overrideScope (self: super: {
      hoogle = self.callHackage "hoogle" "5.0.17.3" {};
    });
    conduit_1_2_13_1 = super.conduit_1_2_13_1.overrideScope
      (self: super: {
        resourcet = self.resourcet_1_1_11;});
    conduit-extra_1_2_3_2 = super.conduit-extra_1_2_3_2.overrideScope
      (self: super: {
        conduit = self.conduit_1_2_13_1;
        resourcet = self.resourcet_1_1_11;});
};

haskellPackageOverrides = myHaskellOverrides;

ghcWithMegaPackagesWithHoogle = haskellPackages.ghcWithHoogle (import ./mega-ghc-package-list.nix);
ghcWithMegaPackages = haskellPackages.ghcWithPackages (import ./mega-ghc-package-list.nix);

ghcEnv = let
  paths = with haskellPackages;
  [ ghcWithMegaPackages#WithHoogle
    alex happy
    ghc-core
    hlint
    ghcid
    pointfree
    hasktags
    djinn
    mueval
    threadscope
    stylish-haskell
  ];
  in
  pkgs.buildEnv {
    name = "ghcEnv";
    inherit paths;
  };

};
}
