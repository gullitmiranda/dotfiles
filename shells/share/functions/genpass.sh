# Generate a random password
genpass() {
	local length="${1:-16}"
	# shellcheck disable=SC2312
	LC_ALL=C tr -dc 'A-Za-z0-9_!@#$%^&*()-+=' </dev/urandom | head -c "${length}" | xargs
}
