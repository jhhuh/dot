{ pkgs ? (import <nixpkgs>{}) }:

with pkgs;

let 
    hsconfig = self: super: { };
    
    newhaskellPackages = haskellPackages.override { overrides = hsconfig; };
    hsenv = newhaskellPackages.ghcWithPackages (p: with p; [
              hscolour ipprint
              xml-conduit split unordered-containers vector-algorithms storable-tuple
              tagged either
              math-functions
            ]);
in stdenv.mkDerivation {
     name = "ghc-shell";
     buildInputs = [ hsenv ];
     shellHook = ''
     '';
   }
