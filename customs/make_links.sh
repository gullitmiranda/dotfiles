#!/bin/sh

# Make Defaults Links
set -e

BASE_PATH=${1:-$BASE_PATH}

if [ ! -n "${BASE_PATH}" ]; then
	BASE_PATH=$(pwd)
fi

echo ":: Making symbolic (custom) links from ${BASE_PATH}"

# Works
ln -sf "$(realpath "../../Works"        )" "${HOME}/"

# ########
# Sensitive data
# ########

ln -sf "${BASE_PATH}/.ssh"              "${HOME}/"

## atom
mkdir -p "${HOME}/.atom"
ln -sf "${BASE_PATH}/.atom"/* "${HOME}/.atom/"
