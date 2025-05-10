# Setup fzf
# ---------
if [[ ${PATH} != */opt/homebrew/opt/fzf/bin* ]]; then
	export PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/opt/homebrew/opt/fzf/shell/completion.bash" 2>/dev/null

# Key bindings
# ------------
source "/opt/homebrew/opt/fzf/shell/key-bindings.bash"

# FZF customization
# ----------------
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
# shellcheck disable=SC2031
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
