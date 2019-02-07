self: super: rec {

  xmonadFull = self.lib.lowPrio (
    super.xmonad-with-packages.override {
      packages = hs: with hs;[ xmonad-contrib xmonad-extras ]; });

  hackage-mirror = with haskell.lib; let
    unpatched = haskell.packages.ghc822.hackage-mirror;
    patched = appendPatch unpatched ../patches/hackage-mirror.patch;
    overridenPatched = patched.overrideScope (hself: hsuper: {
      conduit = hself.conduit_1_2_13_1;
      resourcet = hself.resourcet_1_1_11;
      conduit-extra = hself.conduit-extra_1_2_3_2;
      streaming-commons = hself.callHackage "streaming-commons" "0.1.19" {};
      xml-conduit = hself.xml-conduit_1_7_1_2;
      aeson = doJailbreak (hself.callHackage "aeson" "1.4.2.0" {});
      aws = doJailbreak (dontCheck (hself.callHackage "aws" "0.16" {}));
      conduit-combinators = jailbreak hself.callHackage "conduit-combinators" "1.1.2" {};
      http-conduit = hself.http-conduit_2_2_4; });
  in justStaticExecutables overridenPatched;

  cachix = with self.haskell.lib; let
    overridenCachix = self.haskellPackages.cachix.overrideScope (hself: hsuper: {
      tasty = hself.callHackage "tasty" "1.1.0.4" {};
      servant-server = hself.callHackage "servant-server" "0.14.1" {};
#      insert-ordered-containers = doJailbreak hsuper.insert-ordered-containers;
#      servant-streaming-server = doJailbreak hsuper.servant-streaming-server;
  });
  in (justStaticExecutables overridenCachix).overrideAttrs (drv: {
    meta = drv.meta // {
      hydraPlatforms = stdenv.lib.platforms.unix;};});
  
  myHaskellOverrides = hself: hsuper:
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
      gtk2hs-buildtools = appendPatch hsuper.gtk2hs-buildtools ../patches/gtk2hs-buildtools.patch;
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
    [ ghcWithMegaPackages#WithHoogle
      alex happy
      ghc-core
      hlint
      ghcid
      pointfree
      hasktags
  #    djinn
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
