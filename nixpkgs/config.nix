{ pkgs }: {

allowUnfree = true;

packageOverrides = super: let self = super.pkgs; in with self; rec {

SoundWireServer = self.callPackage ./SoundWireServer {};

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
    ++ [ usbutils vimpc xorg.xwd youtube-dl ] #zathura ]
    ++ [ pythonPackages.pygments ];
};

personalToolsEnv2 = pkgs.buildEnv {
  name = "personalToolsEnv2";
  paths = [ cabal-install cabal2nix cachix ghcEnv ]
    ++ [ discord ffmpeg-full inetutils ipfs irssi jq keynav ]
    ++ [ loc mosh nmap openssl pavucontrol ]
    ++ [ pv python qutebrowser ranger ]
    ++ [ rxvt_unicode-with-plugins ]
    ++ [ scrcpy tmate xcalib xorg.xev xorg.xeyes xkbcomp yasr ]
    ++ [ youtube-dl zathura-with-plugins ];
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

stackage = snapshot: let stackageOverlays = import (fetchTarball {
                                url = "https://stackage.serokell.io/drczwlyf6mi0ilh3kgv01wxwjfgvq14b-stackage/default.nix.tar.gz";
                                sha256 = "1bwlbxx6np0jfl6z9gkmmcq22crm0pa07a8zrwhz5gkal64y6jpz"; });
  in
    (stackageOverlays.${snapshot} self super).haskell.packages.${snapshot};

hackage-mirror = (stackage "lts-6.35").hackage-mirror;

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

  temporary_1_2_1_1 = pkg ./temporary_1_2_1_1 {};

  cabal-helper = super.cabal-helper.override {
    pretty-show = self.pretty-show_1_8_1;
    temporary = temporary_1_2_1_1;
  };

  goa = dontHaddock super.goa;

  streaming-commons_0_1_19 = pkg ./streaming-commons_0_1_19 {};
  aws_0_19 = pkg ./aws_0_19 {};
  aws_0_18 = pkg ./aws_0_18 {};
  aws_0_14_1 = pkg ./aws_0_14_1 {};
  basement_0_0_7 = pkg ./basement_0_0_7 {};
  conduit_1_2_10 = pkg ./conduit_1_2_10 {};
  conduit-extra_1_1_16 = pkg ./conduit-extra_1_1_16 {};
  foundation_0_0_20 = pkg ./foundation_0_0_20 {};
  stm_2_4_5_0 = pkg ./stm_2_4_5_0 {};

  hyper-haskell-server = doJailbreak super.hyper-haskell-server; 
};

haskell = super.haskell // { packageOverrides = myHaskellOverrides;};

ghcWithMegaPackagesWithHoogle = haskellPackages.ghcWithHoogle (import ./mega-ghc-package-list.nix);
ghcWithMegaPackages = haskellPackages.ghcWithPackages (import ./mega-ghc-package-list.nix);

ghcEnv = let
  paths = with haskellPackages;
  [ ghcWithMegaPackagesWithHoogle
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
