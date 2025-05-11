#!/usr/bin/env bash

# Install Bash and bash-completion
brew install --quiet bash bash-completion

# Set DOTFILES_DIR if not already set
if [[ -z ${DOTFILES_DIR} ]]; then
	export DOTFILES_DIR="${HOME}/.dotfiles"
fi

# Create shell stub for .bashrc
"${DOTFILES_DIR}/bin/create_shell_stub" "${HOME}/.bashrc" <<"EOFMARKER"
export DOTFILES_DIR="$DOTFILES_DIR"
source $DOTFILES_DIR/shells/bash/.bashrc
EOFMARKER

# Completion message
echo ""
echo "✅ Bash shell configuration completed. If you want to make it your default shell, run:"
# shellcheck disable=SC2230,SC2312
echo "    chsh -s $(which bash)"
