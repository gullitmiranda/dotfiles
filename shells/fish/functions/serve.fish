# Simple HTTP server in the current directory
function serve
    set -l port 8000
    if test (count $argv) -gt 0
        set port $argv[1]
    end

    if command -v python3 >/dev/null 2>&1
        python3 -m http.server $port
    else if command -v python >/dev/null 2>&1
        python -m SimpleHTTPServer $port
    else
        echo "Python not found, cannot start HTTP server"
        return 1
    end
    echo "Serving HTTP on port $port"
end
