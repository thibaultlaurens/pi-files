#!/usr/bin/env bash

DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

echo "installing unattended-upgrades.."
sudo apt update && sudo apt install unattended-upgrades

echo "creating unattended-upgrades config soft links.."
sudo ln -fs "$DIR/20auto-upgrades" "/etc/apt/apt.conf.d/20auto-upgrades"
sudo ln -fs "$DIR/50unattended-upgrades" "/etc/apt/apt.conf.d/50unattended-upgrades"

echo "restarting unattended-upgrades.."
sudo systemctl enable unattended-upgrade
sudo systemctl restart unattended-upgrade

echo "done"
