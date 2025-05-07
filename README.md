# Gullit Miranda's Dotfiles

## Overview

This repository contains my personal dotfiles - configuration files for various tools and applications I use in my development environment. This is a restructured version with improved organization, better shell parity, and enhanced installation processes.

## Features

- **Shell Parity**: Equivalent configurations for both Fish and ZSH shells
- **Modular Design**: Configurations separated into logical components
- **Secure**: Sensitive data kept out of the repository
- **Simple Installation**: Easy to install and configure
- **Customizable**: Support for local customizations directly in your shell config files
- **Portable**: Uses dynamic paths for easy relocation of the dotfiles repository

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

## Further Documentation

See the [RESTRUCTURING-PLAN.md](RESTRUCTURING-PLAN.md) file for details on the repository design and implementation plan.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
