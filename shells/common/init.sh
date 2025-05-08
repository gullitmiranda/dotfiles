# Source common configuration files for POSIX shells
# This file loads all */*.sh files from subdirectories

# Store current directory to return to it later
CURRENT_DIR=$(pwd)

# Change to common directory for relative paths to work
cd "$(dirname "${BASH_SOURCE[0]}")" || return

# Iterate through each directory in the common folder
for dir in */; do
  if [ -d "$dir" ]; then
    # Source all .sh files in this directory
    for file in "$dir"/*.sh; do
      if [ -f "$file" ]; then
        source "$file"
      fi
    done
  fi
done

# Return to original directory
cd "$CURRENT_DIR" || return