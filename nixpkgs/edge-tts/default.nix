{ pkgs ? import <nixpkgs> {} }:

let

  edge-tts = { lib, buildPythonApplication, fetchPypi, aiohttp, mpv, makeWrapper }:
    buildPythonApplication rec {
      pname = "edge-tts";
      version = "6.1.3";
      src = fetchPypi {
        inherit pname version;
        hash = "sha256-TrDngmJtBiESVscm5C5OQsMxXA9P7i/COUdjsaqKgOc=";
      };

      propagatedBuildInputs = [ aiohttp ];

      makeWrapperArgs = [
        "--prefix PATH : ${lib.makeBinPath [ mpv ]}"
      ];

    };

in

pkgs.python3Packages.callPackage edge-tts { inherit (pkgs) mpv; }
