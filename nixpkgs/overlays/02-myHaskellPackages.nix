self: super: rec {

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
  in self.hiPrio (xmonad-with-packages.overrideAttrs (drv: { name = "xmonadFull"; }));

  ghcWithMegaPackagesWithHoogle = self.haskellPackages.ghcWithHoogle (import ../mega-ghc-package-list.nix);
  ghcWithMegaPackages = self.haskellPackages.ghcWithPackages (import ../mega-ghc-package-list.nix);

  auto-mega-ghc-packages = hp: with self.lib;
    let isNotBroken = p: p ? meta && (if p.meta ? broken then !p.meta.broken else true);
        isAvailable = p: p ? meta && (if p.meta ? available then p.meta.available else true);
        isCandidate = p: isNotBroken p && isAvailable p && isDerivation p;
        isGoodCandidate = name:
          (builtins.tryEval hp.${name}).success
          && hp.${name} ? drvPath
          && (builtins.tryEval hp.${name}.drvPath).success
          && isCandidate hp.${name};
        names = filter isGoodCandidate (attrNames hp);
    in map (name: hp.${name}) names;

  ghcWithAlmostAll =
    let hpkg_list = auto-mega-ghc-packages self.haskellPackages;
    in self.writeText "almost-all-ghc-packages" ''
         ${self.lib.concatMapStrings (n: ''
           ${n}
         '') hpkg_list}
       '';

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
#      threadscope
      stylish-haskell
    ];
    in
    self.buildEnv {
      name = "ghcEnv";
      inherit paths;
    };

}
