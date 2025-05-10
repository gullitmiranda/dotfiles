# Source common configuration files for Fish shell
# This file loads all */*.fish files from subdirectories

# Determine the directory where this script is located
set -l script_dir (dirname (status filename))

for file in $script_dir/*/*.fish
    test -f $file; and source $file
end
