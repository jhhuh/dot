{ inputs }:
  stdenv.mkDerivation {
  pname = "haskell-language-server";
  version = haskellPackages.haskell-language-server.version;
  buildCommand = ''
    mkdir -p $out/bin
    ln -s ${tunedHls (getPackages (builtins.head supportedGhcVersions))}/bin/haskell-language-server-wrapper $out/bin/haskell-language-server-wrapper
    ${concatMapStringsSep "\n" makeSymlinks supportedGhcVersions}
  '';
  meta = haskellPackages.haskell-language-server.meta // {
    maintainers = [ lib.maintainers.maralorn ];
    longDescription = ''
      This package provides the executables ${
        concatMapStringsSep ", " (x: concatStringsSep ", " (targets x))
        supportedGhcVersions
      } and haskell-language-server-wrapper.
      You can choose for which ghc versions to install hls with pkgs.haskell-language-server.override { supportedGhcVersions = [ "90" "92" ]; }.
    '';
  };
}
