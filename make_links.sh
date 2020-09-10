#!/bin/sh

# Make Defaults Links
set -e

BASE_PATH=${1:-$BASE_PATH}
SYNC_DIR_PATH=${SYNC_DIR_PATH:-$HOME/Dropbox}

if [ ! -n "${BASE_PATH}" ]; then
	BASE_PATH=$(pwd)
fi

if [[ ! -d "$SYNC_DIR_PATH" ]]; then
	echo "not found SYNC_DIR_PATH=${SYNC_DIR_PATH}"
	exit 1
fi

echo "==> Making symbolic links"
echo "		BASE_PATH=${BASE_PATH}"
echo "		SYNC_DIR_PATH=${SYNC_DIR_PATH}"

build_link() {
	# get all elements except the last
	echo origin=${@:1:${#@}-1}
	# get last element
	echo target=${@: -1}

	echo "[build_link] link \"$origin\" into \"$target\""
	# ln -sf "$origin" "$target"
	ln -s "$origin" "$target"
}

build_link() {
	build_link "$BASE_PATH/$1" "$HOME/$2"
}

link_to_sync() {
	build_link "$BASE_PATH/$1" "$SYNC_DIR_PATH/$2"
}

# ########
# DOTFILES
# ########

cd "$BASE_PATH"

if [[ "$SHELL" == "zsh" ]]; then
	## terminal and zsh
	build_link .zshrc
	build_link .zdirs
	build_link .zshenv
	build_link .zsh-update
	build_link .oh-my-zsh
	link_to_sync .zsh_history
fi

build_link .tmux.conf

## git
build_link .gitconfig
build_link .gitignore_global .gitignore

build_link .editorconfig
build_link .npmignore
build_link .npmrc

## application settings
mkdir -p "$HOME/.config"
build_link ".config/"* "${HOME}/.config"

if [[ -f "customs/make_links.sh" ]]; then
	cd ./customs
	./make_links.sh
fi
