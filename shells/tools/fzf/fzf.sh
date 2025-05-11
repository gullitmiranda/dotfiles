# Setup fzf

if not command -v fzf >/dev/null 2>&1; then
	echo "fzf not found"
	return 0
fi

# Set up fzf key bindings and fuzzy completion
# shellcheck disable=SC2312
eval "$(fzf --"${CURRENT_SHELL}" || echo "failed to set up \`fzf --${CURRENT_SHELL}\`")"

# FZF customization
# ----------------
# See https://github.com/junegunn/fzf#environment-variables
#
# cycle allows jumping between the first and last results, making scrolling faster
# layout=reverse lists results top to bottom, mimicking the familiar layouts of git log, history, and env
# border shows where the fzf window begins and ends
# height=90% leaves space to see the current command and some scrollback, maintaining context of work
# preview-window=wrap wraps long lines in the preview window, making reading easier
# marker=* makes the multi-select marker more distinguishable from the pointer (since both default to >)
#
# shellcheck disable=SC2031
export FZF_DEFAULT_OPTS='--cycle --layout=reverse --border --height=90% --preview-window=wrap --marker="*"'

# Set up fzf to use fd (https://github.com/sharkdp/fd)
if command -v fd >/dev/null 2>&1; then
	export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
	export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
	export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
fi

# Preview file content using bat (https://github.com/sharkdp/bat)
# CTRL-Y to copy the file content to clipboard
# CTRL-P to copy the file path to clipboard
# CTRL-? to change the preview
if command -v bat >/dev/null 2>&1; then
	export FZF_CTRL_T_OPTS="
		--walker-skip .git,node_modules,target
		--preview 'bat -n --color=always {}'
		--preview-window hidden
		--bind 'ctrl-/:change-preview-window(right|down|hidden|)'
		--bind 'ctrl-y:execute-silent(cat {} | pbcopy)+abort'
		--bind 'ctrl-p:execute-silent(echo {} | pbcopy)'
		--color header:italic
		--header 'Preview: \`CTRL-/\`, Copy: \`CTRL-Y\`, Copy Path: \`CTRL-P\`'"
fi

# CTRL-? to show preview of command
# CTRL-Y to copy the command into clipboard using pbcopy
if command -v pbcopy >/dev/null 2>&1; then
	export FZF_CTRL_R_OPTS="
		--preview 'echo {}'
		--preview-window down:3:hidden:wrap
		--bind 'ctrl-/:change-preview-window(down|hidden|)'
		--bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
		--color header:italic
		--header 'Preview: \`CTRL-/\`, Copy: \`CTRL-Y\`'"
fi

# Print tree structure in the preview window
if command -v eza >/dev/null 2>&1; then
	export FZF_ALT_C_OPTS="
		--walker-skip .git,node_modules,target
		--preview 'eza --tree {} | head -200'"
fi
