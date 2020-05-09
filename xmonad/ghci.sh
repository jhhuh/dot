#! /usr/bin/env bash

nix-shell -p "(import <nixos> {}).haskellPackages.ghcWithPackages (hs: with hs;[xmonad xmonad-contrib xmonad-extras])" --run "ghci"
