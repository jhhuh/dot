#! /usr/bin/env bash

nix-shell -p "haskellPackages.ghcWithPackages (hs: with hs;[xmonad xmonad-contrib xmonad-extras])" --run "ghci"
