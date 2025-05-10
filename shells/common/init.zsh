# Source common configuration files for POSIX shells
# This file loads all */*.sh files from subdirectories

# Current sourced file path
CURRENT_CWD="$DOTFILES_DIR/shells/common/"
if [ -f "$0" ]; then
    CURRENT_CWD="$(dirname "$0")"
fi

for file in $CURRENT_CWD/*/*.{zsh,sh}; do
    [ -f "$file" ] && source "$file"
done
