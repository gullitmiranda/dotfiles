# Common utility functions for all shells
# This file is sourced by all shell configurations

# Create a directory and change into it
mkcd() {
	mkdir -p "$1" && cd "$1" || exit
}

# Extract various compressed file formats
extract() {
	if [[ -f $1 ]]; then
		case "$1" in
		*.tar.bz2) tar xjf "$1" ;;
		*.tar.gz) tar xzf "$1" ;;
		*.bz2) bunzip2 "$1" ;;
		*.rar) unrar e "$1" ;;
		*.gz) gunzip "$1" ;;
		*.tar) tar xf "$1" ;;
		*.tbz2) tar xjf "$1" ;;
		*.tgz) tar xzf "$1" ;;
		*.zip) unzip "$1" ;;
		*.Z) uncompress "$1" ;;
		*.7z) 7z x "$1" ;;
		*) echo "'$1' cannot be extracted via extract()" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

# Find a file with a pattern in name
findfile() {
	find . -type f -name "*$1*"
}

# Find a directory with a pattern in name
finddir() {
	find . -type d -name "*$1*"
}

# Find a file by pattern in current directory
ff() {
	find . -type f -name "$1"
}

# Find text in files
findtext() {
	grep -r "$1" .
}

# Get the current directory's size
dirsize() {
	du -sh "${1:-.}"
}

# Create a new script file with executable permissions
script() {
	if [[ -z $1 ]]; then
		echo "Usage: script <filename>"
		return 1
	fi

	if [[ -e $1 ]]; then
		echo "File already exists: $1"
		return 1
	fi

	echo "#!/usr/bin/env bash" >"$1"
	echo "" >>"$1"
	echo "" >>"$1"
	chmod +x "$1"
	${EDITOR:-vim} "$1"
}

# Quick backup of a file
backup() {
	cp "$1"{,.bak}
}

# Simple HTTP server in the current directory
serve() {
	local port="${1:-8000}"
	if command -v python3 >/dev/null 2>&1; then
		python3 -m http.server "${port}"
	elif command -v python >/dev/null 2>&1; then
		python -m SimpleHTTPServer "${port}"
	else
		echo "Python not found, cannot start HTTP server"
		return 1
	fi
	echo "Serving HTTP on port ${port}"
}

# Weather forecast
weather() {
	local city="${1:-London}"
	curl -s "wttr.in/${city}?m"
}

# Convert timestamp to human-readable date
timestamp() {
	date -d @"$1" 2>/dev/null || date -r "$1" 2>/dev/null || echo "Invalid timestamp"
}

# Generate a random password
genpass() {
	local length="${1:-16}"
	# shellcheck disable=SC2312
	LC_ALL=C tr -dc 'A-Za-z0-9_!@#$%^&*()-+=' </dev/urandom | head -c "${length}" | xargs
}

# IP information
myip() {
	curl -s ifconfig.me
	echo
}

# SSH with a temporary tmux session
ssht() {
	ssh -t "$@" "tmux new -A -s main"
}
