# Fish shell configuration
# Main config file that sources modular components

# Fish Startup Process:
# 1. /etc/fish/config.fish    - System-wide configuration
# 2. ~/.config/fish/conf.d/*.fish - User configuration snippets (loaded alphabetically)
# 3. ~/.config/fish/conf.d/zzz_dotfiles.fish - Dotfiles configuration, that loads this file (alphabetically last)
# 4. ~/.dotfiles/shells/fish/init.fish - This file, that loads the following files:
# 5.    - ~/.dotfiles/shells/share/conf.d/*.fish - Shared configuration snippets
# 6.    - ~/.dotfiles/shells/tools/**/*.fish - Tools configuration snippets
# 7.    - ~/.dotfiles/shells/fish/conf.d/*.fish - Fish configuration snippets
# 8. ~/.config/fish/config.fish - User configuration (this file)
# 9. ~/.config/fish/functions/*.fish - User functions (autoloaded on demand)
# 10. ~/.dotfiles/shells/fish/functions/*.fish - Dotfiles functions (autoloaded on demand)
#
# Note: Unlike Bash, Fish doesn't distinguish between login and non-login shells.
# All interactive fish instances load config.fish files.
# Fish doesn't require explicit checks for interactive mode for key bindings.

# Ensure DOTFILES_DIR is set
if not set -q DOTFILES_DIR
    echo "Error: DOTFILES_DIR environment variable is not set. Please set it to the path of your dotfiles repository."
    exit 1
end

emit perf:timer:start "Dotfiles initialisation"

# Basic shell settings
set -U fish_greeting ""
fish_default_key_bindings

# -----------------------------------------------------------------------------
# Initializers

# Enforce correct shell for when changing between shells
set -gx SHELL (which fish)

# Set the SHELL_TYPE environment variable for starship
set -gx SHELL_TYPE fish

# Load sensitive environment variables (if file exists and not already loaded)
if test -f $DOTFILES_DIR/local/env.sh
    source $DOTFILES_DIR/local/env.sh
end

# append functions to fish autoload path
set -l function_path $DOTFILES_DIR/shells/{tools/**,share,fish}/functions
set fish_function_path $fish_function_path $function_path

# Add fish/completions folder to fish_complete_path
set -l completion_path $DOTFILES_DIR/shells/{tools/**,share,fish}/completions
set fish_complete_path $fish_complete_path $completion_path

emit perf:timer:start "Loading conf.d files"

# autoload conf.d files
for file in \
    $DOTFILES_DIR/shells/tools/**/*.fish \
    $DOTFILES_DIR/shells/{share,fish}/conf.d/*.fish

    # don't load completions files
    if not string match -q '*completions/*.fish' $file
        source $file
    end
end

emit perf:timer:finish "Loading conf.d files"
emit perf:timer:finish "Dotfiles initialisation"
