# Quick backup of a file
function backup
    cp "$argv[1]" "$argv[1].bak"
end
