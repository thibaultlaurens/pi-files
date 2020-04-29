#!/bin/bash

DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

echo "updating openssh-server.."
sudo apt update && sudo apt -y install openssh-server

echo "creating sshd_config soft link.."
sudo ln -fs "$DIR/sshd_config" "/etc/ssh/sshd_config"

echo "restarting ssh.."
sudo systemctl enable ssh
sudo systemctl restart ssh

echo "done"
