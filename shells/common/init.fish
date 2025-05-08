# Source common configuration files for Fish shell
# This file loads all */*.fish files from subdirectories

# Store current directory to return to it later
set -l current_dir (pwd)

# Change to common directory for relative paths to work
cd (dirname (status -f))

# Iterate through each directory in the common folder
for dir in */
    set dir_path (string replace -r '/$' '' $dir)
    if test -d $dir_path
        # Source all .fish files in this directory
        for file in $dir_path/*.fish
            if test -f $file
                source $file
            end
        end
    end
end

# Return to original directory
cd $current_dir