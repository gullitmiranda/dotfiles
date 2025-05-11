#!/bin/sh

dir_is_dotfiles() {
	if [ -f "${1:-$DOTFILES_DIR}/.DOTFILES" ]; then
		return 0
	else
		return 1
	fi
}

# defaults
DEFAULT_DOTFILES_DIR="$(pwd)"
DEFAULT_ZSH="${DOTFILES_DIR}/.oh-my-zsh"

# append `dotfiles` if current directory not is dotfiles dir
if [ ! -n "${DOTFILES_DIR}" ] && ! dir_is_dotfiles ${DEFAULT_DOTFILES_DIR}; then
	DEFAULT_DOTFILES_DIR="${DEFAULT_DOTFILES_DIR}/dotfiles"
fi

export DOTFILES_DIR=${DOTFILES_DIR:-$DEFAULT_DOTFILES_DIR}
export ZSH=${ZSH:-$DEFAULT_ZSH}

# git
clone_repository() {
	echo ":: Cloning dotfiles repository"
	mkdir -p "${DOTFILES_DIR}"
	git clone https://github.com/gullitmiranda/dotfiles "${DOTFILES_DIR}"
}

# oh-my-zsh
install_oh_my_zsh() {
	if [ ! -d "$ZSH" ]; then
		echo ":: Install oh-my-zsh"
		sh -c "`curl -fsSL https://raw.github.com/gullitmiranda/oh-my-zsh/master/tools/install.sh`"
		echo ""
	else
		echo ":: oh-my-zsh alread installed"
	fi
}

# references
make_links() {
	"${DOTFILES_DIR}"/make_links.sh
}

# dotfiles
install_dotfiles() {
	make_links
	install_oh_my_zsh
	touch "${DOTFILES_DIR}/.DOTFILES"
	save_dotfiles_dir
	echo ":: Installed dotfiles with success in ${DOTFILES_DIR}"
}

save_dotfiles_dir() {
	file="$(readlink "${HOME}/.zshrc")"
	new_env="export DOTFILES_DIR=\"${DOTFILES_DIR}\""

	msg() {
		echo ":: $1 env \$DOTFILES_DIR in your ${file} file"
	}

	if grep -q 'export DOTFILES_DIR=' $file; then
		msg "Updating"
		sed -i -e "/export DOTFILES_DIR=/ c\\
		${new_env}
		" $file
	else
		msg "Adding"
		echo "${new_env}" >> $file
	fi
}

if [ ! -d "$DOTFILES_DIR" ]; then
	clone_repository
	install_dotfiles
elif dir_is_dotfiles; then
	install_dotfiles
else
	echo "ERROR: the path ' ${DOTFILES_DIR} ' is no empty or not is dotfiles folder."
	exit 3
fi
