#!/usr/bin/env bash

DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

echo "installing fail2ban.."
sudo apt update && sudo apt install fail2ban

echo "creating jail.local soft link.."
sudo ln -fs "$DIR/jail.local" "/etc/fail2ban/jail.local"

echo "restarting fail2ban.."
sudo systemctl enable fail2ban
sudo systemctl restart fail2ban

echo "done"
