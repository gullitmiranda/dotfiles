# Bash shell configuration
# Main config file that sources modular components

# Ensure DOTFILES_DIR is set
if [ -z "$DOTFILES_DIR" ]; then
    echo "Error: DOTFILES_DIR environment variable is not set. Please set it to the path of your dotfiles repository."
    exit 1
fi

# Basic shell settings
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend
shopt -s checkwinsize
shopt -s globstar 2>/dev/null  # Pattern ** used in pathname expansion
shopt -s autocd 2>/dev/null    # Change directory just by typing the name

# Set default editor
if command -v nvim >/dev/null; then
    export EDITOR=nvim
elif command -v vim >/dev/null; then
    export EDITOR=vim
else
    export EDITOR=nano
fi

# Enable basic completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# -----------------------------------------------------------------------------
# Initializers

# Try to load the ~/.env.sh
[ -f "$HOME/.env.sh" ] && source "$HOME/.env.sh"

# Load https://starship.rs/ if not in WarpTerminal
if [ "$TERM_PROGRAM" != "WarpTerminal" ]; then
    if command -v starship >/dev/null; then
        eval "$(starship init bash)"
    fi
fi