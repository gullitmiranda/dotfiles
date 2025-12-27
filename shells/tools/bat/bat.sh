# Setup bat
# -----------

# For Ubuntu and Debian-based `bat` packages
# the `bat` program is named `batcat` on these systems
if command -v batcat >/dev/null 2>&1; then
	alias bat='batcat'
fi

if command -v bat >/dev/null 2>&1; then
	# Save the original cat command
	rcat() { /bin/cat "$@"; }

	# Bash completions
	if [[ -n "${BASH_VERSION}" ]]; then
		complete -F _cat rcat
	fi

	# Zsh completions
	if [[ -n "${ZSH_VERSION}" ]]; then
		autoload -Uz compinit
		compinit

		autoload -Uz compdef
		autoload -Uz _cat
		compdef _cat cat
		compdef rcat=cat
	fi

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
