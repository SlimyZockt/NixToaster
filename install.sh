#!/usr/bin/env bash
set -e

DIR=$(dirname $(readlink -f $0))
pushd $DIR

cp /etc/nixos/hardware-configuration.nix .

git add .
git commit -am "$(($(git log -1 --pretty=%B) + 1))"

sudo nixos-rebuild switch --flake .

ln -s ./gs.sh ~/.local/bin/gs
ln -s ./nixos-rebuild.sh ~/.local/bin/nixos-rebuild

popd
