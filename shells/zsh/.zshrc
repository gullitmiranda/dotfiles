# Main Zsh Configuration File
# This is sourced by ~/.zshrc which is created by the installer

# Zsh Startup Process:
# 1. /etc/zshenv    - Always run for every zsh session
# 2. ~/.zshenv      - Usually run for every zsh session
# 3. /etc/zprofile  - Run for login shells
# 4. ~/.zprofile    - Run for login shells
# 5. /etc/zshrc     - Run for interactive shells
# 6. ~/.zshrc       - Run for interactive shells (this file)
# 7. /etc/zlogin    - Run for login shells (after zshrc)
# 8. ~/.zlogin      - Run for login shells (after zshrc)
#
# Note: This file (~/.zshrc) is ONLY loaded in interactive shells.
# Key bindings and other interactive features can be set here without checks.
# For more information, see:
# - https://github.com/sorin-ionescu/prezto/tree/master/runcoms#readme
# - https://zsh.sourceforge.io/Doc/Release/zsh_toc.html
# - https://zsh.sourceforge.io/Doc/Release/Files.html#Files

# Set dotfiles directory if not already set
[ -z "$DOTFILES_DIR" ] && export DOTFILES_DIR="$HOME/.dotfiles"

# History configuration
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY      # Share history between all sessions
setopt HIST_IGNORE_DUPS   # Don't record an entry that was just recorded again
setopt HIST_IGNORE_SPACE  # Don't record entries starting with a space
setopt HIST_REDUCE_BLANKS # Remove superfluous blanks from history
setopt HIST_VERIFY        # Don't execute immediately upon history expansion

# Basic zsh options
setopt AUTO_CD              # `dir` instead of `cd dir`
setopt AUTO_PUSHD           # Push the old directory onto the stack on cd
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack
setopt PUSHD_SILENT         # Do not print directory stack after pushd/popd
setopt EXTENDED_GLOB        # Use extended globbing
setopt NULL_GLOB            # Enable nullglob so that non-matching globs expand to an empty string
setopt CORRECT              # Spelling correction
setopt INTERACTIVE_COMMENTS # Allow comments in interactive shells

# Key bindings
bindkey -e                                       # Enable Emacs key bindings mode (Ctrl+A for beginning of line, Ctrl+E for end of line, etc.)
bindkey '^[[A' history-beginning-search-backward # Up arrow - search history backwards matching current input
bindkey '^[[B' history-beginning-search-forward  # Down arrow - search history forwards matching current input
bindkey '^[[H' beginning-of-line                 # Home key - move cursor to beginning of line
bindkey '^[[F' end-of-line                       # End key - move cursor to end of line
bindkey '^[[3~' delete-char                      # Delete key - delete character under cursor
bindkey '^[^[[C' forward-word                    # Option+Right - move cursor forward one word
bindkey '^[^[[D' backward-word                   # Option+Left - move cursor backward one word

# -----------------------------------------------------------------------------
# Initializers

# Enforce correct shell for when changing between shells
export SHELL=$(which zsh)

# Set the SHELL_TYPE environment variable for starship
export SHELL_TYPE=zsh

# Load sensitive environment variables (if file exists and not already loaded)
[ -f "$DOTFILES_DIR/local/env.sh" ] && source "$DOTFILES_DIR/local/env.sh"

# Check for Zinit plugin manager
ZINIT_HOME="$(brew --prefix zinit)"
if [ -f "$ZINIT_HOME/zinit.zsh" ]; then
  source "$ZINIT_HOME/zinit.zsh"
  if [ -f "$DOTFILES_DIR/shells/zsh/zsh_plugins" ]; then
    source "$DOTFILES_DIR/shells/zsh/zsh_plugins"
  fi
else
  echo "Zinit is not installed. Run the $DOTFILES_DIR installer to set it up."
fi

# Enable completion
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case-insensitive matching

# Source configuration files, including completions files
for config_file in "$DOTFILES_DIR"/shells/tools/**/*.{sh,zsh} \
  "$DOTFILES_DIR"/shells/{share,zsh}/{conf.d,functions,completions}/*.{sh,zsh}; do
  source "$config_file"
done
