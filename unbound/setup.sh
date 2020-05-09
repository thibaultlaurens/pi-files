#!/usr/bin/env bash

DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

echo "installing unbound.."
sudo apt update && sudo apt install unbound

# Download the list of primary root servers
echo "downloading the root hints file.."
wget -O root.hints https://www.internic.net/domain/named.root
sudo mv root.hints /var/lib/unbound/

echo "creating unbound config soft link.."
sudo ln -fs "$DIR/pi-hole.conf" "/etc/unbound/unbound.conf.d/pi-hole.conf"

echo "restarting unbound.."
sudo systemctl enable unbound
sudo systemctl restart unbound

echo "all done"
