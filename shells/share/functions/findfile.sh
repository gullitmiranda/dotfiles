# Find a file with a pattern in name
findfile() {
	find . -type f -name "*$1*"
}
