# Create a directory and change into it
function mkcd
    mkdir -p $argv[1] && cd $argv[1]
end
