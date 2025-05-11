# Find a file with a pattern in name
function findfile
    find . -type f -name "*$argv[1]*"
end
