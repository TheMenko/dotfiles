#!/bin/sh

######### INFO ########
# Must be run as root #
#######################

# add unstable channel
nix-channel --add https://nixos.org/channels/nixpkgs-unstable unstable

# update channels
nix-channel --update

# copy stuff to /etc
cp *.nix /etc/nixos

# install
nixos-reload switch