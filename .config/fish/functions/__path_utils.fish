function addpaths
    contains -- $argv $fish_user_paths
    or set -U fish_user_paths $fish_user_paths $argv
    echo "Updated PATH: $PATH"
end

function removepath
    if set -l index (contains -i $argv[1] $PATH)
        set --erase --universal fish_user_paths[$index]
        #     echo "Updated PATH: $PATH"
        # else
        #     echo "$argv[1] not found in PATH: $PATH"
    end
end

funcsave addpaths
funcsave removepath
