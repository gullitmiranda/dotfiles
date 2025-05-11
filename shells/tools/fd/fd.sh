# Setup fd (find alternative)
# ------------
# shellcheck disable=SC2312

if command -v fd >/dev/null 2>&1; then
	# create alias if fd exists
	alias find='fd'

	# Common usage aliases
	alias fdf='fd --type f'             # Find only files
	alias fdd='fd --type d'             # Find only directories
	alias fdh='fd --hidden'             # Include hidden files and directories
	alias fdi='fd --no-ignore'          # Don't respect gitignore
	alias fda='fd --hidden --no-ignore' # Find all files (including hidden and gitignored)

	# Using fd with fzf if available
	if command -v fzf >/dev/null 2>&1; then
		# Select a file with preview
		fdp() {
			fd --type f --hidden --follow --exclude .git |
				fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'
		}

		# Select a directory
		fdir() {
			fd --type d --hidden --follow --exclude .git |
				fzf --preview 'ls -la {}'
		}
	fi

	# Find and replace in files using fd and sd (if available)
	if command -v sd >/dev/null 2>&1; then
		fdr() {
			if [[ $# -ne 2 ]]; then
				echo "Usage: fdr PATTERN REPLACEMENT"
				return 1
			fi
			fd -t f -x sd "$1" "$2" {}
		}
	fi
fi
