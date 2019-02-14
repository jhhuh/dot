self: super: rec {

  stackage2nixPackages = let
    s2np = import ../nixpkgs-stackage/stackage2nix/stackage-packages.nix { nixpkgs = self; };
  in s2np.override {
       overrides = self: super: {
         mtl = null;
         parsec = null;
         stm = null;
         text = null;

         hlibgit2 = super.hlibgit2.overrideAttrs (attr:
           { hardeningDisable = [ "format" ]; });
         http-types = super.http-types.override {};
       };
     };

  stackage2nix = self.callPackage ../nixpkgs-stackage/stackage2nix {
    drv = self.haskell.lib.disableSharedExecutables stackage2nixPackages.stackage2nix;
  };

  xmonadFull =
  let
    wrapper = { stdenv, ghcWithPackages, xmessage, makeWrapper, packages }:
    let xmonadEnv = ghcWithPackages (self: [ self.xmonad ] ++ packages self);
    in stdenv.mkDerivation {
         name = "xmonad-with-packages-${xmonadEnv.version}";
         
         nativeBuildInputs = [ makeWrapper ];
         
         buildCommand = ''
           mkdir -p $out/bin $out/share/man/man1
           ln -s ${xmonadEnv}/share/man/man1/xmonad.1.gz $out/share/man/man1/xmonad.1.gz
           makeWrapper ${xmonadEnv}/bin/xmonad $out/bin/xmonad \
             --set NIX_GHC "${xmonadEnv}/bin/ghc" \
             --set XMONAD_XMESSAGE "${xmessage}/bin/xmessage"
         '';
         
         # trivial derivation
         preferLocalBuild = true;
         allowSubstitutes = false; };
    xmonad-with-packages = self.callPackage wrapper { 
      inherit (self.haskellPackages) ghcWithPackages;
      packages = hs: with hs;[ xmonad-contrib xmonad-extras ]; };
  in xmonad-with-packages.overrideAttrs (drv: { name = "xmonadFull"; });

  cachix = let
    src = self.fetchzip {
      url = "https://github.com/cachix/cachix/archive/v0.1.3.tar.gz";
      sha256 = "09hxrsjmgji2ckxchfskb9km1zqb04sk6kb60p5vqwlvpzy517mb";
    };
  in import src {};

  hackage-mirror = with haskell.lib; let
    unpatched = haskell.packages.ghc822.hackage-mirror;
    patched = appendPatch unpatched ../patches/hackage-mirror.patch;
    overridenPatched = patched.overrideScope (hself: hsuper: {
      conduit = hself.conduit_1_2_13_1;
      resourcet = hself.resourcet_1_1_11;
      conduit-extra = hself.conduit-extra_1_2_3_2;
      streaming-commons = hself.callHackage "streaming-commons" "0.1.19" {};
      xml-conduit = hself.xml-conduit_1_7_1_2;
      aeson = doJailbreak (hself.callHackage "aeson" "1.4.1.0" {});
      aws = doJailbreak (dontCheck (hself.callHackage "aws" "0.16" {}));
      conduit-combinators = jailbreak hself.callHackage "conduit-combinators" "1.1.2" {};
      http-conduit = hself.http-conduit_2_2_4; });
  in justStaticExecutables overridenPatched;

  myHaskellOverrides = myHaskellOverrides_18_09;

  myHaskellOverrides_18_09 = hself: hsuper:
    with self.haskell.lib; let pkg = hself.callPackage; in rec {
    djinn = appendPatch hsuper.djinn ../patches/djinn_2014_9_7.patch;
  };

  myHaskellOverrides_19_03 = hself: hsuper:
    with self.haskell.lib; let pkg = hself.callPackage; in rec {
      heap = dontCheck hsuper.heap;
      doctest-prop = dontCheck hsuper.doctest-prop;
      diagrams-contrib = doJailbreak hsuper.diagrams-contrib;
      diagrams-graphviz = doJailbreak hsuper.diagrams-graphviz;
      diagrams-postscript = doJailbreak hsuper.diagrams-postscript;
      tdigest = doJailbreak hsuper.tdigest;
      servant-docs = doJailbreak hsuper.servant-docs;
      compressed = doJailbreak hsuper.compressed ;
      these = doJailbreak hsuper.these;
      bytestring-show = doJailbreak hsuper.bytestring-show;
#      gtk2hs-buildtools = appendPatch hsuper.gtk2hs-buildtools ../patches/gtk2hs-buildtools.patch;
      threadscope = doJailbreak hsuper.threadscope;
      lambdabot = hsuper.lambdabot.overrideScope (self: super: {
        hoogle = hself.callHackage "hoogle" "5.0.17.3" {};
      });
      conduit_1_2_13_1 = hsuper.conduit_1_2_13_1.overrideScope
        (_self: _super: {
          resourcet = _self.resourcet_1_1_11;});
      conduit-extra_1_2_3_2 = hsuper.conduit-extra_1_2_3_2.overrideScope
        (_self: _super: {
          conduit = _self.conduit_1_2_13_1;
          resourcet = _self.resourcet_1_1_11;});
  };
  
  haskell = super.haskell // { packageOverrides = myHaskellOverrides;};
  
  ghcWithMegaPackagesWithHoogle = self.haskellPackages.ghcWithHoogle (import ../mega-ghc-package-list.nix);
  ghcWithMegaPackages = self.haskellPackages.ghcWithPackages (import ../mega-ghc-package-list.nix);
  
  ghcEnv = let
    paths = with self.haskellPackages;
    [ ghcWithMegaPackagesWithHoogle
      alex happy
      ghc-core
      hlint
      ghcid
      pointfree
      hasktags
      mueval
      threadscope
      stylish-haskell
    ];
    in
    self.buildEnv {
      name = "ghcEnv";
      inherit paths;
    };
}
