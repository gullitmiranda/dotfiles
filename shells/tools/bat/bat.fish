# Setup bat
# -----------
# For Ubuntu and Debian-based `bat` packages
# the `bat` program is named `batcat` on these systems
if command -v batcat >/dev/null 2>&1
    alias bat batcat
end

if command -v bat >/dev/null 2>&1
    # Save the original cat command
    function rcat
        /bin/cat $argv
    end
    complete -c rcat -w /bin/cat

    # Set the BAT_THEME environment variable
    set -gx BAT_THEME "Monokai Extended"

    # Use bat for manpages (colored)
    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"

    # Set paging options
    set -gx BAT_PAGER "less -R"

    # Line numbers, Git modifications and file header
    set -gx BAT_STYLE "numbers,changes,header"

    # Aliases
    alias cat 'bat --paging=never'
    alias less bat
end
