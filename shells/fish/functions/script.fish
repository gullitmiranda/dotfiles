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

    echo "#!/usr/bin/env bash" >"$argv[1]"
    echo "" >>"$argv[1]"
    echo "" >>"$argv[1]"
    chmod +x "$argv[1]"
    eval $EDITOR "$argv[1]"
end
