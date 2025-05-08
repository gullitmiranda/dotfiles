# ZSH shell configuration
# Main config file that sources modular components

# Ensure DOTFILES_DIR is set
if [ -z "$DOTFILES_DIR" ]; then
    echo "Error: DOTFILES_DIR environment variable is not set. Please set it to the path of your dotfiles repository."
    exit 1
fi

# Load core modules
for file in "$DOTFILES_DIR"/core/env.d/*.sh; do
    if [ -f "$file" ]; then
        source "$file"
    fi
done

for file in "$DOTFILES_DIR"/core/paths.d/*.sh; do
    if [ -f "$file" ]; then
        source "$file"
    fi
done

for file in "$DOTFILES_DIR"/core/aliases.d/*.sh; do
    if [ -f "$file" ]; then
        source "$file"
    fi
done

for file in "$DOTFILES_DIR"/core/functions.d/*.sh; do
    if [ -f "$file" ]; then
        source "$file"
    fi
done

# Basic shell settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# Basic completion system
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select

# Set default editor
if command -v nvim >/dev/null; then
    export EDITOR=nvim
elif command -v vim >/dev/null; then
    export EDITOR=vim
else
    export EDITOR=nano
fi

# Check for Zinit plugin manager
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [ -d "$ZINIT_HOME" ]; then
    source "$ZINIT_HOME/zinit.zsh"
    if [ -f "$DOTFILES_DIR/shells/zsh/zsh_plugins" ]; then
        source "$DOTFILES_DIR/shells/zsh/zsh_plugins"
    fi
else
    echo "Zinit is not installed. Run the dotfiles installer to set it up."
fi
