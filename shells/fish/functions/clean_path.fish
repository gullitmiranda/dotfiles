#!/usr/bin/env fish

# Function to clean PATH by removing non-existent directories
function clean_path
    set -l new_path
    for dir in $PATH
        if test -d "$dir"
            set -a new_path "$dir"
        end
    end
    set -gx PATH $new_path
end

# Run clean_path when the shell starts
clean_path
