# Setup fzf

if not command -v fzf >/dev/null 2>&1; then
	echo "fzf not found"
	return 0
fi

# Set up fzf key bindings and fuzzy completion
# shellcheck disable=SC2312
eval "$(fzf --"${SHELL_TYPE}" || echo "failed to set up \`fzf --${SHELL_TYPE}\`")"

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

# Configure fzf-tab for enhanced command completion
# https://github.com/Aloxaf/fzf-tab/wiki/Configuration
# ----------------
# Show detailed command information in the preview window
if [[ -n "${ZSH_VERSION}" ]]; then
	## Defaults
	###########

	# # trigger fzf-tab when pressing `/`
	# zstyle ':fzf-tab:*' continuous-trigger '/'

	## Customization
	#################

	# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
	zstyle ':completion:*' menu no

	# preview directory's content with eza when completing cd
	# switch group using `<` and `>`
	zstyle ':fzf-tab:*' switch-group '<' '>'

	# set descriptions format to enable group support
	# # NOTE: don't use escape sequences here, fzf-tab will ignore them
	# zstyle ':completion:*:descriptions' format '[%d]'
	zstyle ':completion:*:descriptions' format

	# show group name in the preview window
	zstyle ':fzf-tab:*' show-group

	### Preview
	###########

	# shellcheck disable=SC2016
	# preview directory's content with eza when completing cd
	zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'

	# shellcheck disable=SC2016
	# give a preview of commandline arguments when completing `kill`
	zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
		'[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'

	# # give a preview of commandline arguments when completing `kill`
	# zstyle ':completion:*:*:*:*:processes' command "ps -u ${USER} -o pid,user,comm -w -w"
	# # shellcheck disable=SC2016
	# zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
	# 	'[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
	# zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

	## AI Generated
	#################

	# # Show command description in preview window
	# zstyle ':fzf-tab:*' show-group full
	# zstyle ':fzf-tab:*' switch-group ',' '.'
	# zstyle ':fzf-tab:*' fzf-pad 4
	# zstyle ':fzf-tab:*' fzf-flags --preview-window=right:70%

	# # Show command descriptions and help text
	# zstyle ':fzf-tab:complete:(ls|cat|bat|vim|nvim|nano|less|more|head|tail):*' fzf-preview 'bat --color=always --style=numbers --line-range=:500 $realpath'
	# zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --tree --level=2 --color=always $realpath'
	# zstyle ':fzf-tab:complete:git:*' fzf-preview 'git help $word 2>/dev/null || git help $word 2>&1 | bat --color=always --plain'
	# zstyle ':fzf-tab:complete:man:*' fzf-preview 'man $word | bat --color=always --plain'
	# zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
	# 	fzf-preview 'echo ${(P)word}'

	# # Show command descriptions
	# zstyle ':completion:*:descriptions' format '%F{green}%B%d%b%f'
	# zstyle ':completion:*' group-name ''
fi
