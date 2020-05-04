#!/usr/bin/env bash

DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

echo "setting up pihole.."

# Setup firewall.
source "$DIR/iptables.sh"

# Download pi-hole installer.
wget -O "$DIR/install.sh" https://install.pi-hole.net

# Run the install script.
read -r -p "Confirm $DIR/install.sh execution [yes|y]: " resp
case "$resp" in
    [yY][eE][sS]|[yY])
        sudo bash "$DIR/install.sh" ;;
    *) exit ;;
esac

echo "all done"
