#!/usr/bin/env bash

cat /nix/store/vwpdkj5ajpm0rs2g7wasqk7rc4my84bm-update-firefox-devedition-bin-unwrapped-61.0b8 |
  sed 's/pushd.*/pushd ./' |
  sed 's/xidel -q/xidel -s/' > update.sh

chmod +x update.sh

