#! /bin/sh

channel="nixos-19.03"
rev=$(curl -L https://nixos.org/channels/"$channel"/git-revision | tee ./git-revision_nixpkgs)

source ./update_nix-channel.sh
