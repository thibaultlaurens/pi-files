#!/usr/bin/env bash

DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

echo "setting up raspbian.."

# Install packages.
source "$DIR/apt.sh"

# Setup custom bash aliases.
source "$DIR/bash/setup.sh"

# Setup ssh.
source "$DIR/ssh/setup.sh"

# Setup firewall.
source "$DIR/iptables.sh"

# Setup unattended-upgrades.
source "$DIR/unattended-upgrades/setup.sh"

# Setup fail2ban.
source "$DIR/fail2ban/setup.sh"

# Setup watchdog.
source "$DIR/watchdog/setup.sh"

# Uncomment to setup pi-hole and unbound.
# source pihole/setup.sh
# source unbound/setup.sh

echo "all done"
