#!/bin/sh

# Make Defaults Links
set -e
BASE_PATH=$HOME/Sync/gullitmiranda@gmail.com

# ########
# DOTFILES
# ########

## atom
base=${BASE_PATH}/dotfiles/.atom
to=${HOME}/.atom/
mkdir -p ${to}
ln -sf ${base}/* ${to}/
