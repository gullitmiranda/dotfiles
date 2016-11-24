#!/bin/sh

# Make Defaults Links
set -e

BASE_PATH=${1:-$BASE_PATH}

if [ ! -n "${BASE_PATH}" ]; then
	BASE_PATH=$(pwd)
fi

echo ":: Making symbolic links from ${BASE_PATH}"

# ########
# DOTFILES
# ########

## terminal and zsh
ln -sf "${BASE_PATH}/.tmux.conf"        "${HOME}/"
ln -sf "${BASE_PATH}/.zshrc"            "${HOME}/"
ln -sf "${BASE_PATH}/.zdirs"            "${HOME}/"
ln -sf "${BASE_PATH}/.zshenv"           "${HOME}/"
ln -sf "${BASE_PATH}/.zsh-update"       "${HOME}/"
ln -sf "${BASE_PATH}/.zsh_history"      "${HOME}/"
ln -sf "${BASE_PATH}/.oh-my-zsh"        "${HOME}/"

## git
ln -sf "${BASE_PATH}/.gitconfig"        "${HOME}/"
ln -sf "${BASE_PATH}/.gitignore_global" "${HOME}/.gitignore"

ln -sf "${BASE_PATH}/.editorconfig"     "${HOME}/"
ln -sf "${BASE_PATH}/.npmignore"        "${HOME}/"
ln -sf "${BASE_PATH}/.npmrc"            "${HOME}/"

## application settings
mkdir -p "${HOME}/.config"
ln -sf "${BASE_PATH}/.config/"*         "${HOME}/.config"

if [[ -f "customs/make_links.sh" ]]; then
	cd ./customs
	./make_links.sh
fi
