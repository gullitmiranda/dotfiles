# Find text in files
function findtext
    grep -r "$argv[1]" .
end
