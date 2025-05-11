# Setup fd (find alternative)
# ------------

if command -v fd >/dev/null 2>&1
    # create alias if fd exists
    alias find fd

    # Common usage aliases
    alias fdf 'fd --type f' # Find only files
    alias fdd 'fd --type d' # Find only directories
    alias fdh 'fd --hidden' # Include hidden files and directories
    alias fdi 'fd --no-ignore' # Don't respect gitignore
    alias fda 'fd --hidden --no-ignore' # Find all files (including hidden and gitignored)

    # Using fd with fzf if available
    if command -v fzf >/dev/null 2>&1
        # Select a file with preview
        function fdp
            fd --type f --hidden --follow --exclude .git \
                | fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'
        end

        # Select a directory
        function fdir
            fd --type d --hidden --follow --exclude .git \
                | fzf --preview 'ls -la {}'
        end
    end

    # Find and replace in files using fd and sd (if available)
    if command -v sd >/dev/null 2>&1
        function fdr
            if test (count $argv) -ne 2
                echo "Usage: fdr PATTERN REPLACEMENT"
                return 1
            end
            fd -t f -x sd $argv[1] $argv[2] {}
        end
    end
end
