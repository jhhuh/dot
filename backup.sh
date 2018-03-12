#!/bin/sh

#sudo sh -c "cp /etc/nixos/*.nix ./etc_nixos && chown $USER:users ./etc_nixos/*.nix"

machine=$(hostname)
mkdir -p ./etc_nixos/$machine

for fn in /etc/nixos/*;
do
    cat $fn > ./etc_nixos/$machine/$(basename $fn)
done
