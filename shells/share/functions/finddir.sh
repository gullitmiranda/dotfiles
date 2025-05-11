# Find a directory with a pattern in name
finddir() {
	find . -type d -name "*$1*"
}
