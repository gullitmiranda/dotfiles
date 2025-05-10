# Fish shell configuration
# Main config file that sources modular components

# Ensure DOTFILES_DIR is set
if not set -q DOTFILES_DIR
    echo "Error: DOTFILES_DIR environment variable is not set. Please set it to the path of your dotfiles repository."
    exit 1
end

# Basic shell settings
set -U fish_greeting ""
fish_default_key_bindings

# -----------------------------------------------------------------------------
# Initializers

# if the file ~/.env.sh exists, source it
if test -f ~/.env.sh
    source ~/.env.sh
end

# Source common configuration files
if test -f $DOTFILES_DIR/shells/common/init.fish
    source $DOTFILES_DIR/shells/common/init.fish
end

# Load https://starship.rs/ if not in WarpTerminal and if the starship command exists
if test "$TERM_PROGRAM" != WarpTerminal && type -q starship
    starship init fish | source
end
