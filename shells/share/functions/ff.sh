# Find a file by pattern in current directory
ff() {
	find . -type f -name "$1"
}
