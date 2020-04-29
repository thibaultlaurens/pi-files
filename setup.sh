#!/bin/bash

DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

echo "setting up raspbian.."

# install packages
source "$DIR/apt.sh"

# setup custom bash aliases
source "$DIR/bash/setup.sh"

# setup ssh
source "$DIR/ssh/setup.sh"

echo "all done."
