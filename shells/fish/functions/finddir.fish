# Find a directory with a pattern in name
function finddir
    find . -type d -name "*$argv[1]*"
end
