# ZSH shell configuration
# Main config file that sources modular components

# Ensure DOTFILES_DIR is set
if [ -z "$DOTFILES_DIR" ]; then
    echo "Error: DOTFILES_DIR environment variable is not set. Please set it to the path of your dotfiles repository."
    exit 1
fi

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

# -----------------------------------------------------------------------------
# Initializers

# try to load the ~/.env.sh
[ -f "~/.env.sh" ] && source ~/.env.sh

# Load https://starship.rs/ if not in WarpTerminal
if [ "$TERM_PROGRAM" != "WarpTerminal" ]; then
    eval "$(starship init zsh)"
fi

# Check for Zinit plugin manager
ZINIT_HOME="$(brew --prefix zinit)"
if command -v zinit; then
    source "$ZINIT_HOME/zinit.zsh"
    if [ -f "$DOTFILES_DIR/shells/zsh/zsh_plugins" ]; then
        source "$DOTFILES_DIR/shells/zsh/zsh_plugins"
    fi
else
    echo "Zinit is not installed. Run the $DOTFILES_DIR installer to set it up."
fi
