#! /usr/bin/env bash

channel="nixos-21.05"
rev=$(curl -L https://nixos.org/channels/"$channel"/git-revision | tee ./git-revision_nixpkgs)

source ./update_nix-channel.sh
