# Fish shell configuration
# Main config file that sources modular components

# Ensure DOTFILES_DIR is set
if not set -q DOTFILES_DIR
    echo "Error: DOTFILES_DIR environment variable is not set. Please set it to the path of your dotfiles repository."
    exit 1
end

# Load core modules
for file in $DOTFILES_DIR/core/env.d/*.fish
    if test -e $file
        source $file
    end
end

for file in $DOTFILES_DIR/core/paths.d/*.fish
    if test -e $file
        source $file
    end
end

for file in $DOTFILES_DIR/core/aliases.d/*.fish
    if test -e $file
        source $file
    end
end

for file in $DOTFILES_DIR/core/functions.d/*.fish
    if test -e $file
        source $file
    end
end

# Basic shell settings
set -U fish_greeting ""
fish_default_key_bindings

# Set default editor
if command -v nvim >/dev/null
    set -gx EDITOR nvim
else if command -v vim >/dev/null
    set -gx EDITOR vim
else
    set -gx EDITOR nano
end

