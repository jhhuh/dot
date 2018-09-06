#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix

cat $(nix-build --no-out-link "<nixpkgs>" -A firefox-devedition-bin-unwrapped.updateScript) |
  sed 's/pushd.*/pushd ./' |
  sed 's/xidel -q/xidel -s/' > update.sh

chmod +x update.sh

