# Find a file by pattern in current directory
function ff
    find . -type f -name "$argv[1]"
end
