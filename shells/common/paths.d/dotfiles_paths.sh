# Add dotfiles bin directory to PATH
# This file is sourced by all shells through their respective shell adapters

# Add bin directory to PATH if not already included
if [[ ":${PATH}:" != *":${DOTFILES_DIR}/bin:"* ]]; then
	export PATH="${DOTFILES_DIR}/bin:${PATH}"
fi
