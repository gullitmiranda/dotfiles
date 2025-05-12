#!/usr/bin/env zsh

# Set DOTFILES_DIR if not already set
if [[ -z "$DOTFILES_DIR" ]]; then
  export DOTFILES_DIR="$HOME/.dotfiles"
fi

# Create shell stub for .zshrc
$DOTFILES_DIR/bin/create_shell_stub "$HOME/.zshrc" <<EOFMARKER
export DOTFILES_DIR="$DOTFILES_DIR"
source $DOTFILES_DIR/shells/zsh/.zshrc
EOFMARKER

if test -f "$DOTFILES_DIR/shells/zsh/zsh_plugins"; then
  echo "Installing Zinit plugins from $DOTFILES_DIR/shells/zsh/zsh_plugins"
  zinit update --all

  echo ""
  echo "✅ Zinit plugins installed. You can manage plugins with these commands:"
  echo "    zinit update --all           # To update all plugins"
  echo "    zinit light <plugin-url>     # To add a plugin"
  echo "    zinit delete <plugin-name>   # To remove a plugin"
  echo ""
  echo "  Or edit $DOTFILES_DIR/shells/zsh/zsh_plugins and run 'zinit update --all'"
fi

# Completion message
echo ""
echo "✅ Zsh shell configuration completed. If you want to make it your default shell, run:"
echo "    chsh -s $(which zsh)"
