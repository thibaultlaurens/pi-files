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

# Setup fail2ban.
source "$DIR/fail2ban/setup.sh"

# Setup watchdog.
source "$DIR/watchdog/setup.sh"

echo "all done"
