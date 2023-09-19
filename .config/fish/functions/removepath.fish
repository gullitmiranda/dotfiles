function removepath -d "remove path from universal \$fish_user_paths"
    if set -l index (contains -i $argv[1] $fish_user_paths)
        set --erase --universal fish_user_paths[$index]
    end
end
