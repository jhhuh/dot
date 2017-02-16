#!/bin/sh

sudo sh -c "cp /etc/nixos/*.nix ./etc_nixos && chown $USER:users ./etc_nixos/*.nix"

