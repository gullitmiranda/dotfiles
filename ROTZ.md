# Using Rotz with this Dotfiles Repository

## What is Rotz?

Rotz is a powerful, cross-platform dotfile manager and development environment bootstrapper written in Rust. It provides:

- Symbolic linking of dotfiles from your repository to your system
- Installation of software packages across different platforms
- Distributed configuration for better organization
- Full cross-platform support

## Installation

### Install Rotz

```bash
# macOS with Homebrew
brew install volllly/tap/rotz

# Linux with Cargo (requires Rust)
cargo install rotz

# Using installation scripts
curl -fsSL volllly.github.io/rotz/install.sh | sh  # Unix-based systems
```

### Setup Repository

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Initialize Rotz
rotz init
```

## Configuration Structure

This repository uses Rotz's distributed configuration model where each application has its own dot.yaml file.

### Central Configuration (`config.yaml`)

The root `config.yaml` contains general settings and references to scripts:

```yaml
# Example config.yaml structure
general:
  backup: true
  verbose: false

packages:
  common:
    - git
    - vim

install_scripts:
  pre:
    - tools/install/pre_install_brew.sh
  post:
    - tools/install/post_install_shell.sh
```

### Application-specific Configuration (`dot.yaml`)

Each application directory contains its own `dot.yaml` file that follows this structure:

```yaml
linux|darwin: # Platform-specific section
  links:
    # Source files (relative to dot.yaml location) → Target locations
    config.file: ~/.config/app/config.file
    directory: ~/.config/app/directory/

  installs:
    cmd: brew install app
    depends:
      - tools/brew
```

Examples from this repository:

- `shells/fish/dot.yaml` - Fish shell configuration
- `shells/zsh/dot.yaml` - Zsh shell configuration
- `editors/vim/dot.yaml` - Vim configuration
- `editors/nvim/dot.yaml` - Neovim configuration
- `git/dot.yaml` - Git configuration
- `core/dot.yaml` - Core shared configurations

## Directory Structure

```
dotfiles/
├── core/                 # Shell-agnostic configurations
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

## Commands

### Essential Commands

```bash
# Deploy all dotfiles
rotz link

# Deploy specific application dotfiles
rotz link shells/fish editors/vim

# Install software packages
rotz install

# Both operations
rotz link install

# Show verbose output
rotz --verbose link

# Dry run (show changes without applying)
rotz --dry-run link
```

### Advanced Commands

```bash
# Unlink all dotfiles
rotz unlink

# Generate a new config file
rotz init --generate

# Update a cloned repository and deploy
rotz pull link
```

## Adding New Dotfiles

1. Place your dotfile in the appropriate application directory
2. Update that directory's `dot.yaml` file to include the new link

Example for adding a Fish shell configuration file:

1. Add `my_config.fish` to `shells/fish/`
2. Update `shells/fish/dot.yaml`:
   ```yaml
   linux|darwin:
     links:
       # Add your new file
       my_config.fish: ~/.config/fish/conf.d/my_config.fish
   ```
3. Run `rotz link` to deploy

## Adding a New Application

To add a new application category:

1. Create a directory for your application: `mkdir dotfiles/new-app`
2. Create a `dot.yaml` file within that directory:

   ```yaml
   linux|darwin:
     links:
       config: ~/.config/new-app/config

     installs:
       cmd: brew install new-app
       depends:
         - tools/brew
   ```

3. Add your configuration files to this directory
4. Run `rotz link` to deploy

## Package Management

Rotz manages software installation using the specifications in dot.yaml files:

```bash
# Install all defined packages
rotz install

# Install only specific applications
rotz install shells/fish
```

## Dependencies

Applications can depend on each other using the `depends` directive in their installation configuration:

```yaml
installs:
  cmd: brew install app
  depends:
    - tools/brew # This ensures Homebrew is installed first
```

## Platform-Specific Configuration

Each dot.yaml can have platform-specific sections:

```yaml
# For both macOS and Linux
linux|darwin:
  links:
    config: ~/.config/app/config

# macOS only
darwin:
  links:
    macos_config: ~/Library/Preferences/app.plist

# Linux only
linux:
  links:
    linux_config: ~/.local/share/app/config
```

## Troubleshooting

Common issues and solutions:

- **Files not linking properly**:

  - Check paths in dot.yaml files
  - Use `rotz --verbose link` to see details
  - Run `rotz --dry-run link` to preview changes

- **Package installation issues**:

  - Check package names for your platform
  - Verify the `depends` paths are correct
  - Manually run the install commands to debug

- **Dependency problems**:
  - Check if dependent applications exist
  - Make sure the path in `depends` is correct

## Further Resources

- [Official Rotz Documentation](https://github.com/volllly/rotz)
- [Rotz Website](https://volllly.github.io/rotz/)
- [Configuration Reference](https://volllly.github.io/rotz/docs/configuration)
