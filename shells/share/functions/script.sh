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
