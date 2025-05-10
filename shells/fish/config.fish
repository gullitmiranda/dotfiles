# Fish shell configuration
# Main config file that sources modular components

# Fish Startup Process:
# 1. /etc/fish/config.fish    - System-wide configuration
# 2. ~/.config/fish/conf.d/*.fish - User configuration snippets (loaded alphabetically)
# 3. ~/.config/fish/config.fish - User configuration (this file)
# 4. ~/.config/fish/functions/*.fish - User functions (autoloaded on demand)
#
# Note: Unlike Bash, Fish doesn't distinguish between login and non-login shells.
# All interactive fish instances load config.fish files.
# Fish doesn't require explicit checks for interactive mode for key bindings.

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

# Set the CURRENT_SHELL environment variable for starship
set -gx CURRENT_SHELL fish

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
