# Common utility functions for Fish shell
# This file is sourced by the Fish shell configuration

# Create a directory and change into it
function mkcd
    mkdir -p $argv[1] && cd $argv[1]
end

# Extract various compressed file formats
function extract
    if test -f $argv[1]
        switch $argv[1]
            case '*.tar.bz2'
                tar xjf $argv[1]
            case '*.tar.gz'
                tar xzf $argv[1]
            case '*.bz2'
                bunzip2 $argv[1]
            case '*.rar'
                unrar e $argv[1]
            case '*.gz'
                gunzip $argv[1]
            case '*.tar'
                tar xf $argv[1]
            case '*.tbz2'
                tar xjf $argv[1]
            case '*.tgz'
                tar xzf $argv[1]
            case '*.zip'
                unzip $argv[1]
            case '*.Z'
                uncompress $argv[1]
            case '*.7z'
                7z x $argv[1]
            case '*'
                echo "'$argv[1]' cannot be extracted via extract()"
        end
    else
        echo "'$argv[1]' is not a valid file"
    end
end

# Find a file with a pattern in name
function findfile
    find . -type f -name "*$argv[1]*"
end

# Find a directory with a pattern in name
function finddir
    find . -type d -name "*$argv[1]*"
end

# Find a file by pattern in current directory
function ff
    find . -type f -name "$argv[1]"
end

# Find text in files
function findtext
    grep -r "$argv[1]" .
end

# Get the current directory's size
function dirsize
    du -sh $argv[1]
end

# Create a new script file with executable permissions
function script
    if test -z "$argv[1]"
        echo "Usage: script <filename>"
        return 1
    end

    if test -e "$argv[1]"
        echo "File already exists: $argv[1]"
        return 1
    end

    echo "#!/usr/bin/env bash" > "$argv[1]"
    echo "" >> "$argv[1]"
    echo "" >> "$argv[1]"
    chmod +x "$argv[1]"
    eval $EDITOR "$argv[1]"
end

# Quick backup of a file
function backup
    cp "$argv[1]" "$argv[1].bak"
end

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

# Weather forecast
function weather
    set -l city "London"
    if test (count $argv) -gt 0
        set city $argv[1]
    end
    curl -s "wttr.in/$city?m"
end

# Generate a random password
function genpass
    set -l length 16
    if test (count $argv) -gt 0
        set length $argv[1]
    end
    LC_ALL=C tr -dc 'A-Za-z0-9_!@#$%^&*()-+=' < /dev/urandom | head -c $length | xargs
end

# IP information
function myip
    curl -s ifconfig.me
    echo
end

# SSH with a temporary tmux session
function ssht
    ssh -t $argv "tmux new -A -s main"
end
