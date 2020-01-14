#! /usr/bin/env bash

nix-channel --add https://github.com/nixos/nixpkgs/archive/$(<git-revision_nixpkgs).tar.gz nixpkgs
nix-channel --list
nix-channel --update nixpkgs
