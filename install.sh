#!/usr/bin/env bash

cp /etc/nixos/hardware-configuration.nix .

git add .
git commit -am "$(($(git log -1 --pretty=%B) + 1))"

sudo nixos-rebuild switch --flake .

