#!/usr/bin/env bash
set -e

DIR=$(dirname $(readlink -f $0))
pushd $DIR

cp /etc/nixos/hardware-configuration.nix .

git add .
git commit -am "$(($(git log -1 --pretty=%B) + 1))"

sudo nixos-rebuild switch --flake .

cp ./gs.sh ~/.local/bin/
cp ./nixos-rebuild.sh ~/.local/bin/

popd
