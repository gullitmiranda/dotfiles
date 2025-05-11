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
