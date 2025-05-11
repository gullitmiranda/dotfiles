# Convert timestamp to human-readable date
timestamp() {
	date -d @"$1" 2>/dev/null || date -r "$1" 2>/dev/null || echo "Invalid timestamp"
}
