# Gullit Miranda's Dotfiles

## Overview

This repository contains my personal dotfiles - configuration files for various tools and applications I use in my development environment. This is a restructured version with improved organization, better shell parity, and enhanced installation processes, now using [Rotz](https://github.com/volllly/rotz) for dotfile management.

## Features

- **Shell Parity**: Equivalent minimal configurations for Fish, Zsh, and Bash shells
- **Modular Design**: Configurations separated into logical components
- **Secure**: Sensitive data kept out of the repository
- **Simple Installation**: Easy to install and configure
- **Customizable**: Support for local customizations directly in your shell config files
- **Portable**: Uses dynamic paths for easy relocation of the dotfiles repository
- **Plugin Management**: Consistent plugin management for both Fish and Zsh shells
- **Minimal Core**: Streamlined shell configurations with only essential functionality

## Repository Structure

```plaintext
dotfiles/
├── shells/               # Shell-specific configurations
│   ├── common/           # Shell-agnostic configurations shared across shells
│   │   ├── env.d/        # Environment variables
│   │   ├── aliases.d/    # Aliases organized by category
│   │   ├── functions.d/  # Shared functions
│   │   └── paths.d/      # Path additions
│   ├── fish/             # Fish shell configuration (with its own dot.yaml)
│   ├── zsh/              # Zsh shell configuration (with its own dot.yaml)
│   ├── bash/             # Bash shell configuration (with its own dot.yaml)
│   ├── share/            # Shared configurations (completions, functions, snippets)
│   └── tools/            # Tool-specific shell integrations (starship, fzf, etc.)
├── editors/              # Editor configurations
│   ├── vim/              # Vim configuration (with its own dot.yaml)
│   └── nvim/             # Neovim configuration (with its own dot.yaml)
├── bin/                  # Executable scripts (added to path)
├── tools/                # Installation tools
│   ├── link/             # Dotfile linking scripts
│   └── network/          # Network configuration tools
└── packages/             # Package management
    ├── Brewfile.core     # Essential packages
    ├── Brewfile.dev      # Development tools
    └── Brewfile.gui      # GUI applications
```

Each shell's configuration follows the same minimal pattern, focusing on essential functionality while providing a solid foundation for customization. This makes it easy to switch between shells or maintain both simultaneously.

## Rotz Setup

This dotfiles repository uses [Rotz](https://github.com/volllly/rotz) - a powerful, cross-platform dotfile manager and environment bootstrapper written in Rust.

### Installation

First, install Rotz:

```shell
# macOS with Homebrew
brew install volllly/tap/rotz

# Using installation scripts
curl -fsSL volllly.github.io/rotz/install.sh | sh  # Unix-based systems
```

Then initialize your dotfiles:

```shell
# If you've already cloned the repository
cd ~/.dotfiles
rotz init

# Or clone and initialize in one step
rotz clone https://github.com/gullitmiranda/dotfiles.git
```

### Configuring Rotz

Now you should update the config file to your needs.

The default config file is `~/Library/Application Support/com.rotz/config.yaml`:

you can use a custom one by:

- running `rotz init --config ~/.dotfiles/config.yaml`
- Or creating a link `~/.dotfiles/config.yaml` to the custom one after running `rotz init`:

  ```bash
  ln -s ~/Library/Application\ Support/com.rotz/config.yaml ~/.dotfiles/config.yaml
  ```

> The `config.yaml` file is this repository's is ignored by git, so you can change it as you want.

### Deploying Your Dotfiles

After installing Rotz and initializing your dotfiles, you can setup them:

```bash
# Link and install all applications
rotz link
rotz install

# Link and install only specific applications
rotz link shells/tools/* shells/fish
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

- **`dot.yaml`** - Configuration files in each application directory with structure:

  ```yaml
  linux|darwin: # Platform-specific section
    links: # Defines source: target file mappings
      config.file: ~/.config/app/config.file

    installs: # Optional installation instructions
      cmd: brew install app
  ```

Each component has its own independent configuration, eliminating the need for a central configuration file. Shared shell configurations are shared through the `shells/share` directory.

This modular approach allows for better organization and platform-specific configuration.

## Customization

### Machine-Specific Configurations

Rotz provides several options for machine-specific configurations:

- **Platform-specific packages** in `config.yaml`
- **Templates** for files that need slight variations between machines
- **Separate scripts** that can detect and adapt to different environments
- **Variable substitution** using `{{ config.variable }}` syntax in scripts and templates
- Changes are applied with simple `rotz link` and `rotz install` commands

### Local Overrides

For truly machine-specific settings that shouldn't be in the repository:

- Add your customizations to the local files created during installation (e.g., ~/.zshrc.local)
- Store sensitive data in ~/.env.sh (which is automatically sourced by the shell configs)
- These changes will be preserved when updating your dotfiles

## Plugin Management

This repository provides a minimal foundation with plugin management capabilities:

### Shell Configurations

#### Fish Shell

- Plugin system through [Fisher](https://github.com/jorgebucaran/fisher) - a lightweight plugin manager
- Plugins can be defined in [shells/fish/fish_plugins](./shells/fish/fish_plugins) (contains example plugins as comments)
- Add a plugin: Edit `fish_plugins` file or run `fisher add <plugin-url>`
- Install/update plugins: `fisher update`

> See [Fish for bash users](https://fishshell.com/docs/current/fish_for_bash_users.html) to see the differences between fish and bash shells.

#### Zsh Shell

- Plugin system through [Zinit](https://github.com/zdharma-continuum/zinit) - a lightweight plugin manager
- Plugins can be defined in [shells/zsh/zsh_plugins](./shells/zsh/zsh_plugins) (contains example plugins as comments)
- Add a plugin: Uncomment or add new plugin lines in the `zsh_plugins` file
- Install/update plugins: `zinit update --all`

#### Bash Shell

- Basic configuration with modern defaults
- Compatible with the same shared functionality as Fish and Zsh
- Perfect for servers or environments where Bash is preferred

#### Starship Prompt

- Cross-shell prompt customization using [Starship](https://starship.rs/)
- Consistent look and feel across all shells

Both plugin managers are automatically installed during setup, and plugin files are kept outside the repository.

## Package Management

There are two approaches to package management with this configuration:

### 1. Direct installation in dot.yaml files

```yaml
# Example in shell/zsh/dot.yaml
linux|darwin:
  installs:
    cmd: |
      # Install Zsh packages
      brew install zsh zinit starship
```

### 2. Using Brewfiles (for grouped installations)

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

- Multiple Git accounts (work, personal) with per-directory routing via `mise`
- HTTPS authentication via `gh` CLI (recommended, no 1Password dependency)
- 1Password SSH integration (legacy fallback)
- Commit signing

## Updating

### Updating Your Dotfiles

To update your dotfiles after making changes to your dotfiles repository:

```bash
# Pull the latest changes from the repository
cd ~/.dotfiles
git pull

# Apply the updated configuration and install packages
rotz link install
```

### Advanced Usage

```bash
# Dry run to preview changes without applying them
rotz --dry-run link

# Show verbose output for debugging
rotz --verbose link

# Work with specific components only
rotz link shells/fish editors/vim

# Unlink all dotfiles
rotz unlink

# Restore backups
rotz restore
```

For plugin updates:

- Fish: `fisher update`
- Zsh: `zinit update --all`

## Troubleshooting

Common issues and solutions:

- **Files not linking properly**: Run `rotz link --verbose` to see detailed output
- **Packages not installing**: Check package names in component-specific `dot.yaml` files
- **Plugins not working**: Run the appropriate update command for your shell
- **Permission issues**: Ensure scripts have execute permissions with `chmod +x $DOTFILES_DIR/bin/*`
- **Dependency problems**: Verify that the paths in `depends` sections are correct
- **Platform-specific issues**: Make sure you're using the right platform section (`linux|darwin`, `darwin`, or `linux`)
- **Missing variables**: Check that all template variables are properly defined

## Further Documentation

See the [RESTRUCTURING-PLAN.md](RESTRUCTURING-PLAN.md) file for details on the repository design and implementation plan. For more information about Rotz and how it's used in this repository, check out [ROTZ.md](ROTZ.md).

For detailed Rotz documentation, visit the [official Rotz website](https://volllly.github.io/rotz/).

## Homebrew Integration

This configuration supports two approaches for Homebrew package management:

1. **Direct installation in dot.yaml files** - Better for component-specific packages that are tightly coupled to a particular tool or shell
2. **Brewfiles** - Better for organizing larger groups of packages by category (core, development, GUI apps)

The choice depends on your specific needs:

- Use direct `brew install` commands for simplicity and immediate installation
- Use Brewfiles for better organization and documentation of package groups

## License

This project is licensed under the MIT License - see the LICENSE file for details.
