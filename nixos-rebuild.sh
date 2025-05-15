#!/usr/bin/env bash

DIR=$(dirname $(readlink -f $0))

set -e
pushd $DIR
nvim .

git add .

git diff -U0 *.nix

git commit -am "$(($(git log -1 --pretty=%B) + 1))"
echo "Nixos Rebulding ..."
sudo nixos-rebuild switch --flake .
git push

popd
