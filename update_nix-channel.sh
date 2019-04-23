#! /bin/sh
nix-channel --add https://github.com/nixos/nixpkgs/archive/$(<git-revision_nixpkgs).tar.gz nixpkgs
nix-channel --update nixpkgs
