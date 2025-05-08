# Gullit Miranda's Dotfiles

## Overview

This repository contains my personal dotfiles - configuration files for various tools and applications I use in my development environment. This is a restructured version with improved organization, better shell parity, and enhanced installation processes.

## Features

- **Shell Parity**: Equivalent minimal configurations for both Fish and ZSH shells
- **Modular Design**: Configurations separated into logical components
- **Secure**: Sensitive data kept out of the repository
- **Simple Installation**: Easy to install and configure
- **Customizable**: Support for local customizations directly in your shell config files
- **Portable**: Uses dynamic paths for easy relocation of the dotfiles repository
- **Plugin Management**: Consistent plugin management for both Fish and Zsh shells
- **Minimal Core**: Streamlined shell configurations with only essential functionality

## Repository Structure

```
dotfiles/
├── core/                 # Shell-agnostic configurations
│   ├── env.d/            # Environment variables
│   ├── aliases.d/        # Aliases organized by category
│   ├── functions.d/      # Shared functions
│   └── paths.d/          # Path additions
├── shells/               # Shell-specific configurations
│   ├── fish/             # Fish shell
│   └── zsh/              # ZSH shell
├── config/               # Application configs
├── home/                 # Files for $HOME directory
├── bin/                  # Executable scripts
├── tools/                # Installation tools
└── packages/             # Package management
```

Each shell's configuration follows the same minimal pattern, focusing on essential functionality while providing a solid foundation for customization. This makes it easy to switch between shells or maintain both simultaneously.

## Installation

### Quick Start

```bash
# Clone the repository
git clone https://github.com/gullitmiranda/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Run the installer
./tools/install.sh
```

### Advanced Installation

For more options:

```bash
./tools/install.sh --help    # Show installation options
./tools/install.sh --minimal # Minimal installation
./tools/install.sh --shell=fish # Set preferred shell
```

## Customization

Add your machine-specific configurations directly to your shell configuration files:

- `~/.config/fish/config.fish` for Fish shell (after the line that sources from dotfiles)
- `~/.zshrc` for ZSH shell (after the line that sources from dotfiles)

The installer creates these files with a designated section for your customizations that won't be overwritten when updating the dotfiles repository.

## Plugin Management

This repository provides a minimal foundation with plugin management capabilities:

### Fish Shell
- Plugin system through [Fisher](https://github.com/jorgebucaran/fisher) - a lightweight plugin manager
- Plugins can be defined in `shells/fish/fish_plugins` (contains example plugins as comments)
- Install/update plugins: `fisher update`
- Add a plugin: Edit `fish_plugins` file or run `fisher add <plugin-url>`

### Zsh Shell
- Plugin system through [Zinit](https://github.com/zdharma-continuum/zinit) - a lightweight plugin manager
- Plugins can be defined in `shells/zsh/zsh_plugins` (contains example plugins as comments)
- Install/update plugins: `zinit update --all`
- Add a plugin: Uncomment or add new plugin lines in the `zsh_plugins` file

Both plugin managers are automatically installed during setup, and plugin files are kept outside the repository.

## Package Management

Install recommended packages:

```bash
# Install core packages
brew bundle --file=packages/Brewfile.core

# Install development tools
brew bundle --file=packages/Brewfile.dev

# Install GUI applications
brew bundle --file=packages/Brewfile.gui
```

## Git Integration

This repository includes support for:

- Multiple Git accounts (work, personal)
- 1Password SSH integration
- Git credential helpers
- Commit signing

## Updating

To update your dotfiles after making changes:

```bash
# Pull the latest changes from the repository
cd ~/.dotfiles
git pull

# Run the installer to apply any new configurations
./tools/install.sh
```

For plugin updates:
- Fish: `fisher update`
- Zsh: `zinit update --all`

## Troubleshooting

Common issues and solutions:

- **Shell doesn't load configurations**: Ensure `DOTFILES_DIR` is set correctly
- **Plugins not working**: Run the appropriate update command for your shell
- **Permission issues**: Ensure the scripts have execute permissions (`chmod +x tools/*.sh`)

## Further Documentation

See the [RESTRUCTURING-PLAN.md](RESTRUCTURING-PLAN.md) file for details on the repository design and implementation plan.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
