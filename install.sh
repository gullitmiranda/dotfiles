#!/bin/sh
# defaults
DEFAULT_DOTFILES_PATH="$(pwd)/.dotfiles"
DEFAULT_ZSH="${DOTFILES_PATH}/.oh-my-zsh"

# if [ ! -n "${DOTFILES_PATH}" ]; then
# fi

export DOTFILES_PATH=${DOTFILES_PATH:-$DEFAULT_DOTFILES_PATH}
export ZSH=${ZSH:-$DEFAULT_ZSH}

# git
clone_repository() {
	echo "cloning dotfiles repository"
	mkdir -p "${DOTFILES_PATH}"
	git clone https://github.com/gullitmiranda/dotfiles "${DOTFILES_PATH}"
}

# oh-my-zsh
install_oh_my_zsh() {
	if [ ! -d "$ZSH" ]; then
		sh -c "`curl -fsSL https://raw.github.com/gullitmiranda/oh-my-zsh/master/tools/install.sh`"
	fi
}

upgrade_oh_my_zsh() {
	if [ -d "$ZSH" ]; then
	else
		$ZSH/tools/install.sh
	fi
}

# references
make_links() {
	echo "make links to relevant files"
	"${DOTFILES_PATH}"/make_links.sh
}

# dotfiles
install_dotfiles() {
	make_links
	install_oh_my_zsh
	touch "${DOTFILES_PATH}/.DOTFILES"
}

dir_is_dotfiles() {
	if [ -f "${DOTFILES_PATH}/.DOTFILES" ]; then
		true
	else
		false
	fi
}

if [ ! -d "$DOTFILES_PATH" ]; then
	clone_repository
	install_dotfiles
elif dir_is_dotfiles; then
	install_dotfiles
else
	echo "the path ' ${DOTFILES_PATH} ' is no empty or not is dotfiles folder."
	exit 3
fi
