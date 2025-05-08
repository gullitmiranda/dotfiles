# Add dotfiles bin directory to PATH
# This file is sourced by the Fish shell configuration

fish_add_path --path "$DOTFILES_DIR/bin"

# # Add bin directory to PATH if not already included
# contains "$DOTFILES_DIR/bin" $PATH; or fish_add_path --path "$DOTFILES_DIR/bin"
# if not contains "$DOTFILES_DIR/bin" $PATH
#   fish_add_path --path "$DOTFILES_DIR/bin"
# end
