#!/usr/bin/env bash

DIR=$(dirname $(readlink -f $0))

set -e
pushd $DIR
nvim .

git add .

git diff -U0 *.nixa

git commit -am "$(($(git log -1 --pretty=%B) + 1))"
echo "Nixos Rebulding ..."
sudo nixos-rebuild switch --flake . &>nixos-switch.log || (
    cat nixos-switch.log  && false
    )
git push

popd
