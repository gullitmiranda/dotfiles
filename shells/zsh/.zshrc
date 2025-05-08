# Main Zsh Configuration File
# This is sourced by ~/.zshrc which is created by the installer

# Set dotfiles directory if not already set
[ -z "$DOTFILES_DIR" ] && export DOTFILES_DIR="$HOME/.dotfiles"

# History configuration
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY        # Share history between all sessions
setopt HIST_IGNORE_DUPS     # Don't record an entry that was just recorded again
setopt HIST_IGNORE_SPACE    # Don't record entries starting with a space
setopt HIST_REDUCE_BLANKS   # Remove superfluous blanks from history
setopt HIST_VERIFY          # Don't execute immediately upon history expansion

# Basic zsh options
setopt AUTO_CD              # `dir` instead of `cd dir`
setopt AUTO_PUSHD           # Push the old directory onto the stack on cd
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack
setopt PUSHD_SILENT         # Do not print directory stack after pushd/popd
setopt EXTENDED_GLOB        # Use extended globbing
setopt CORRECT              # Spelling correction
setopt INTERACTIVE_COMMENTS # Allow comments in interactive shells

# Completion
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case-insensitive matching

# Key bindings
bindkey -e                              # Emacs key bindings
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# -----------------------------------------------------------------------------
# Initializers

# Load sensitive environment variables (if file exists and not already loaded)
[ -f "$HOME/.env.sh" ] && source "$HOME/.env.sh"

# Source common configuration
[ -f "$DOTFILES_DIR/shells/common/init.sh" ]; then source "$DOTFILES_DIR/shells/common/init.sh"

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

# Initialize Starship prompt if available and not in Warp Terminal
if [ "$TERM_PROGRAM" != "WarpTerminal" ] && command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
