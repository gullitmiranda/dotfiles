# ripgrep configuration
# -----------------------

# Make sure ripgrep is installed
if command -v rg >/dev/null 2>&1; then
	# Define helper aliases for common search patterns
	alias rgh='rg --hidden'
	alias rgf='rg --files | rg'
	alias rgc='rg --count'

	# Integration with fzf if available
	if command -v fzf >/dev/null 2>&1; then
		# Interactive ripgrep
		rgfzf() {
			RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
			INITIAL_QUERY="${*-}"
			# shellcheck disable=SC2312
			: | fzf --ansi --disabled --query "${INITIAL_QUERY}" \
				--bind "start:reload:${RG_PREFIX} {q}" \
				--bind "change:reload:sleep 0.1; ${RG_PREFIX} {q} || true" \
				--delimiter : \
				--preview 'bat --color=always {1} --highlight-line {2}' \
				--preview-window 'up,60%,border-bottom,+{2}+3/3,~3'
		}
	fi
fi
