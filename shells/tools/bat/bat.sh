# Setup bat
# -----------
if command -v bat >/dev/null 2>&1; then
	# Set the BAT_THEME environment variable
	export BAT_THEME="Monokai Extended"

	# Use bat for manpages (colored)
	export MANPAGER="sh -c 'col -bx | bat -l man -p'"

	# Set paging options
	export BAT_PAGER="less -R"

	# Line numbers, Git modifications and file header
	export BAT_STYLE="numbers,changes,header"

	# Aliases
	alias cat='bat --paging=never'
	alias less='bat'
fi
