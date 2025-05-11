# Get the current directory's size
dirsize() {
	du -sh "${1:-.}"
}
