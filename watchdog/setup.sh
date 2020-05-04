#!/usr/bin/env bash

DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

echo "installing watchdog.."
sudo apt update && sudo apt install watchdog

echo "creating watchdog.services soft link.."
sudo ln -f "/lib/systemd/system/watchdog.service" "/etc/systemd/system/multi-user.target.wants/watchdog.service"

echo "creating watchdog.conf soft link.."
sudo ln -sf "$DIR/watchdog.conf" "/etc/watchdog.conf"

echo "restarting watchdog.."
sudo systemctl restart watchdog

echo "done"
