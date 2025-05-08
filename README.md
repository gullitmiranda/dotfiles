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
├── core/                 # Shell-agnostic configurations (with dot.yaml)
│   ├── env.d/            # Environment variables
│   ├── aliases.d/        # Aliases organized by category
│   ├── functions.d/      # Shared functions
│   └── paths.d/          # Path additions
├── shells/               # Shell-specific configurations
│   ├── fish/             # Fish shell (with its own dot.yaml)
│   └── zsh/              # ZSH shell (with its own dot.yaml)
├── editors/              # Editor configurations
│   ├── vim/              # Vim configuration (with its own dot.yaml)
│   └── nvim/             # Neovim configuration (with its own dot.yaml)
├── git/                  # Git configuration (with its own dot.yaml)
├── bin/                  # Executable scripts
├── tools/                # Installation tools
│   ├── install/          # Package installation scripts
│   ├── link/             # Dotfile linking scripts
│   └── brew/             # Homebrew installation (with its own dot.yaml)
├── config.yaml           # Central Rotz configuration
└── dot.yaml              # Root configuration (for bin/ linking)
```

Each shell's configuration follows the same minimal pattern, focusing on essential functionality while providing a solid foundation for customization. This makes it easy to switch between shells or maintain both simultaneously.

## Rotz Setup

This dotfiles repository uses [Rotz](https://github.com/volllly/rotz) - a powerful, cross-platform dotfile manager and environment bootstrapper written in Rust.

### Installation

First, install Rotz:

```shell
# macOS with Homebrew
brew install volllly/tap/rotz
```

Then initialize your dotfiles:

```shell
# If you've already cloned the repository
cd ~/.dotfiles
rotz init

# Or clone and initialize in one step
rotz clone https://github.com/gullitmiranda/dotfiles.git
```

Now you can follow the instructions bellow to setup it in your machine:

## Usage

### Deploying Your Dotfiles

After installing Rotz and initializing your dotfiles, you can setup them:

```bash
# Link and install all applications
rotz link
rotz install

# Link and install only specific applications
rotz link shells/fish editors/*
```

### Seting default shell

To make sure that you are using the latest zsh installation as your default shell, run:

```shell
chsh -s $(which zsh)
```

Or you can use fish instead. run:

```shell
chsh -s $(which fish)
```

### Sensitive Environment Variables

You can set up the [~/.env.sh](~/.env.sh) file for sensitive environment variables with the following command as example:

```bash
# init a empty file
touch ~/.env.sh

# or a content
cat > ~/.env.sh << 'EOF'
# Sensitive environment variables
export GITHUB_TOKEN=""

# AI Platforms API Keys
export ANTHROPIC_API_KEY=""
export OPENAI_API_KEY=""
export GOOGLE_AI_API_KEY=""
export GEMINI_API_KEY=""
export DEEPSEEK_API_KEY=""
EOF

chmod 600 ~/.env.sh  # Set permissions to be readable only by you
```

This creates the file with proper permissions and prepares it for your sensitive data.

### Configuration

Rotz uses a distributed configuration model in this repository:

- **`config.yaml`** - Central configuration file at the repository root that defines:
  - General settings
  - Package installation references
  - References to pre/post installation and linking scripts

- **`dot.yaml`** - Configuration files in each application directory with structure:
  ```yaml
  linux|darwin:    # Platform-specific section
    links:         # Defines source: target file mappings
      config.file: ~/.config/app/config.file

    installs:      # Optional installation instructions
      cmd: brew install app
      depends:
        - tools/brew
  ```

- **Root `dot.yaml`** - Simple configuration at the repository root for linking the bin directory

This modular approach allows for better organization and platform-specific configuration.

## Customization

### Machine-Specific Configurations

Rotz provides several options for machine-specific configurations:

- **Platform-specific packages** in `config.yaml`
- **Templates** for files that need slight variations between machines
- **Separate scripts** that can detect and adapt to different environments
- Changes are applied with simple `rotz link` and `rotz install` commands

### Local Overrides

For truly machine-specific settings that shouldn't be in the repository:

- Add your customizations to the files after they've been deployed
- Use separate local configuration files referenced from your main config
- These changes will be preserved when updating your dotfiles

## Plugin Management

This repository provides a minimal foundation with plugin management capabilities:

### Fish Shell
- Plugin system through [Fisher](https://github.com/jorgebucaran/fisher) - a lightweight plugin manager
- Plugins can be defined in [shells/fish/fish_plugins](./shells/fish/fish_plugins) (contains example plugins as comments)
- Add a plugin: Edit `fish_plugins` file or run `fisher add <plugin-url>`
- Install/update plugins: `fisher update`

> See [Fish for bash users](https://fishshell.com/docs/current/fish_for_bash_users.html) to see the differences between fish and bash shells.

### Zsh Shell
- Plugin system through [Zinit](https://github.com/zdharma-continuum/zinit) - a lightweight plugin manager
- Plugins can be defined in [shells/zsh/zsh_plugins](./shells/zsh/zsh_plugins) (contains example plugins as comments)
- Add a plugin: Uncomment or add new plugin lines in the `zsh_plugins` file
- Install/update plugins: `zinit update --all`

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

### Updating Your Dotfiles

To update your dotfiles after making changes to your dotfiles repository:

```bash
# Pull the latest changes from the repository
cd ~/.dotfiles
git pull

# Apply the updated configuration
rotz link

# Update software packages
rotz install
```

For plugin updates:
- Fish: `fisher update`
- Zsh: `zinit update --all`

## Troubleshooting

Common issues and solutions:

- **Files not linking properly**: Run `rotz link --verbose` to see detailed output
- **Packages not installing**: Check package names in `config.yaml` and package-specific `dot.yaml` files
- **Plugins not working**: Run the appropriate update command for your shell
- **Permission issues**: Ensure scripts have execute permissions with `chmod +x $DOTFILES_DIR/bin/*`

## Further Documentation

See the [RESTRUCTURING-PLAN.md](RESTRUCTURING-PLAN.md) file for details on the repository design and implementation plan. For more information about Rotz and how it's used in this repository, check out [ROTZ.md](ROTZ.md).

## License

This project is licensed under the MIT License - see the LICENSE file for details.
