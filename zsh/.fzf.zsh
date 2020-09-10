# Setup fzf
# ---------
if [[ ! "$PATH" == *${HOME}/odrive/pessoal/dotfiles/.config/nvim/plugged/fzf/bin* ]]; then
  export PATH="$PATH:${HOME}/odrive/pessoal/dotfiles/.config/nvim/plugged/fzf/bin"
fi

# Man path
# --------
if [[ ! "$MANPATH" == *${HOME}/odrive/pessoal/dotfiles/.config/nvim/plugged/fzf/man* && -d "${HOME}/odrive/pessoal/dotfiles/.config/nvim/plugged/fzf/man" ]]; then
  export MANPATH="$MANPATH:${HOME}/odrive/pessoal/dotfiles/.config/nvim/plugged/fzf/man"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "${HOME}/odrive/pessoal/dotfiles/.config/nvim/plugged/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "${HOME}/odrive/pessoal/dotfiles/.config/nvim/plugged/fzf/shell/key-bindings.zsh"

