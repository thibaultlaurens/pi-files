#!/bin/bash

DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

echo "installing bash.."
sudo apt update && sudo apt install -y bash bash-completion

echo "creating .bash_aliases soft link.."
ln -fs "$DIR/.bash_aliases" "$HOME/.bash_aliases"

echo "reloading bashrc.."
source "$HOME/.bashrc"

echo "done"
