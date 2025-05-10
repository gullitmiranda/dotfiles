# Bash shell configuration
# Main config file that sources modular components

# Bash Startup Process:
# 1. /etc/profile             - Run for login shells
# 2. ~/.bash_profile, ~/.bash_login, or ~/.profile (in that order) - Run for login shells
# 3. /etc/bash.bashrc         - Run for interactive non-login shells (some distros)
# 4. ~/.bashrc                - Run for interactive non-login shells (this file)
#
# Note: Unlike Zsh, Bash's ~/.bashrc may be sourced in both interactive and non-interactive contexts.
# This is why we check for interactive shells with if [[ $- == *i* ]] before setting key bindings.
# Modern terminal emulators usually run non-login interactive shells, which source only .bashrc.

# Ensure DOTFILES_DIR is set
if [ -z "$DOTFILES_DIR" ]; then
  echo "Error: DOTFILES_DIR environment variable is not set. Please set it to the path of your dotfiles repository."
  exit 1
fi

# Basic shell settings
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=10000
HISTFILESIZE=20000
HISTFILE=~/.bash_history
shopt -s histappend
shopt -s checkwinsize
shopt -s globstar 2>/dev/null  # Pattern ** used in pathname expansion
shopt -s autocd 2>/dev/null    # Change directory just by typing the name
shopt -s dirspell 2>/dev/null  # Correct minor spelling errors in cd commands
shopt -s cdspell 2>/dev/null   # Correct minor spelling errors in cd commands
shopt -s cmdhist               # Save multi-line commands as one history entry
shopt -s lithist               # Store multi-line commands with newlines
shopt -s expand_aliases        # Expand aliases
shopt -s direxpand 2>/dev/null # Expand directory globs when completing

# Directory navigation (similar to zsh AUTO_PUSHD)
shopt -s autocd 2>/dev/null                # Change directory just by typing the name
shopt -s cdable_vars                       # If cd arg is not a directory, assume it's a variable
pushd() { command pushd "$@" >/dev/null; } # Make pushd quiet
popd() { command popd "$@" >/dev/null; }   # Make popd quiet
alias d='dirs -v'                          # List directory stack

# Enable interactive comments (# at the beginning of the line)
shopt -s interactive_comments

# Key bindings (similar to zsh configuration)
# Enable Emacs key bindings mode
set -o emacs

# These key bindings work in interactive mode
if [[ $- == *i* ]]; then
  # Up/down arrow for history search
  bind '"\e[A": history-search-backward' # Up arrow - search history backwards matching current input
  bind '"\e[B": history-search-forward'  # Down arrow - search history forwards matching current input

  # Home/End keys
  bind '"\e[H": beginning-of-line' # Home key - move cursor to beginning of line
  bind '"\e[F": end-of-line'       # End key - move cursor to end of line

  # Delete key
  bind '"\e[3~": delete-char' # Delete key - delete character under cursor

  # Word navigation with Option+arrows
  bind '"\e\e[C": forward-word'  # Option+Right - move cursor forward one word
  bind '"\e\e[D": backward-word' # Option+Left - move cursor backward one word
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

# Set the CURRENT_SHELL environment variable for starship
export CURRENT_SHELL=bash

# Try to load the ~/.env.sh
[ -f "$HOME/.env.sh" ] && source "$HOME/.env.sh"

# Source common configuration
[ -f "$DOTFILES_DIR/shells/common/init.bash" ] && source "$DOTFILES_DIR/shells/common/init.bash"

# Load https://starship.rs/ if not in WarpTerminal
if [ "$TERM_PROGRAM" != "WarpTerminal" ]; then
  if command -v starship >/dev/null; then
    eval "$(starship init bash)"
  fi
fi
