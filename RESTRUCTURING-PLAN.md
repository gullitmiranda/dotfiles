# Dotfiles Repository Restructuring Plan

## Overview

This document outlines the plan for restructuring the dotfiles repository to create a more maintainable, secure, and user-friendly configuration system. The repository now uses [Rotz](https://github.com/volllly/rotz), a powerful cross-platform dotfile manager and environment bootstrapper written in Rust, to manage the dotfiles and installation process.

## Core Principles

1. **Shell Parity**: Maintain equivalent functionality between Fish and ZSH (with added support for Bash)
2. **Separation of Concerns**: Cleanly separate shared configuration from machine-specific settings
3. **Simplified Installation**: Make setup straightforward for new machines using Rotz
4. **Security**: Keep sensitive data out of the repository
5. **Distributed Configuration**: Use Rotz's distributed configuration model for better organization
6. **Cross-Platform Support**: Ensure configurations work across different operating systems

## 1. Repository Structure

```
dotfiles/
├── shells/               # Shell-specific configurations
│   ├── common/           # Shell-agnostic configurations shared across shells
│   │   ├── env.d/        # Environment variables
│   │   ├── aliases.d/    # Aliases organized by category
│   │   ├── functions.d/  # Shared functions
│   │   └── paths.d/      # Path additions
│   ├── fish/             # Fish shell (with its own dot.yaml)
│   ├── zsh/              # ZSH shell (with its own dot.yaml)
│   ├── bash/             # Bash shell (with its own dot.yaml)
│   └── starship/         # Starship prompt configuration
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

## 2. Configuration Approach

The repository now uses Rotz's distributed configuration model instead of direct symlinking:

### Key Components:

1. **Distributed Configuration**: Each shell and application has its own `dot.yaml` file
2. **Symbolic Linking**: Rotz manages the symbolic links from your repository to your system
3. **Platform-Specific Configuration**: Support for different operating systems in the same configuration file
4. **Template System**: Use templates with placeholders for sensitive data
5. **Shell Common Files**: Shared shell configurations in `shells/common` directory

### Configuration Files:

#### Rotz Configuration:
Each component has its own `dot.yaml` file which contains all necessary configuration for that component. This distributed approach eliminates the need for a central `config.yaml` file.

#### Application-specific Config (`dot.yaml`):
```yaml
linux|darwin:  # Platform-specific section
  links:
    # Source files (relative to dot.yaml location) → Target locations
    config.file: ~/.config/app/config.file
    directory: ~/.config/app/directory/

  installs:
    cmd: brew install app
    depends:
      - tools/brew
```

#### Shell Stub Example (created by install scripts):
```bash
# ~/.zshrc (minimal stub installed by script)
export DOTFILES_DIR=/path/to/your/dotfiles
source $DOTFILES_DIR/shells/zsh/.zshrc
```

## 3. Installation System

Using Rotz for installation provides a streamlined, cross-platform approach:

### Main Installer Commands

```bash
# Install Rotz
brew install volllly/tap/rotz  # macOS
cargo install rotz             # Using Rust/Cargo

# Initialize repository
rotz init                      # In an existing repository
rotz clone <repository-url>    # Clone and initialize

# Deploy dotfiles
rotz link                      # Link all dotfiles
rotz link shells/fish          # Link specific components

# Install software packages (directly in dot.yaml files)
rotz install                   # Install all packages
rotz install shells/fish       # Install specific components
```

### Key Features:

1. **Idempotent Installation**: Safe to run multiple times without breaking things
2. **Distributed Configuration**: Each component has its own configuration
3. **Dependency Management**: Supports dependencies between components
4. **Cross-Platform Support**: Configurations can be platform-specific
5. **Backup**: Automatically creates backups of existing configurations before replacement
6. **Dry Run**: Preview changes without applying them

## 4. Shell Parity Features

### Supported Shells
The repository now supports three shell environments:
- Fish (modern, user-friendly shell)
- Zsh (powerful, extensible shell)
- Bash (legacy support)

### Shared Logic
Place all shared functionality in `shells/common/` directory:
- Environment variables
- Aliases
- Path management
- Common functions

### Plugin Management
Each shell includes its own plugin management system:
- Fish: [Fisher](https://github.com/jorgebucaran/fisher)
- Zsh: [Zinit](https://github.com/zdharma-continuum/zinit)

### Shell Specific Configuration
Each shell has its own `dot.yaml` file that defines:
- Files to link
- Installation commands
- Plugin installation
- Stub configuration creation

### Feature Matrix
Features implemented across different shells:

| Feature              | Fish Implementation             | ZSH Implementation             | Bash Implementation         |
|----------------------|---------------------------------|---------------------------------|-----------------------------|
| Environment Variables| `set -gx VAR value`            | `export VAR=value`             | `export VAR=value`          |
| Path Addition        | `fish_add_path /usr/local/bin` | `export PATH=/usr/local/bin:$PATH` | `export PATH=/usr/local/bin:$PATH` |
| Aliases              | `alias g="git"`                | `alias g="git"`                | `alias g="git"`             |
| Plugin Management    | Fisher                         | Zinit                          | (minimal)                   |
| Prompt Customization | Starship                       | Starship                       | Starship                    |

## 5. Security Improvements

### Rotz Template System:
Rotz supports variable substitution in configuration files:
```yaml
# Example dot.yaml with templating
linux|darwin:
  links:
    gitconfig.template: ~/.gitconfig

  installs:
    cmd: |
      echo "Configuring git with {{ config.user_email }}"
      git config --global user.email "{{ config.user_email }}"
```

### Environment Variables File:
```bash
# ~/.env.sh (git-ignored)
# Sensitive environment variables
export GITHUB_TOKEN="your-token"
export API_KEY="your-key"
```

### Local Configuration
Machine-specific configurations are stored in local user files that are not part of the repository:
- API keys in `~/.env.sh`
- Work-specific configurations in shell-specific local files
- Personal preferences in application-specific configuration files

## 6. Version Control Integration

### Git Configuration with Rotz:
```yaml
# Example git/dot.yaml
linux|darwin:
  links:
    gitconfig: ~/.gitconfig
    gitignore_global: ~/.gitignore_global
    # Additional git configuration files

  installs:
    cmd: |
      # Configure git defaults
      git config --global core.editor "vim"
      git config --global init.defaultBranch "main"
```

### Multiple Git Account Support:
```
git/
├── gitconfig              # Main config that includes others
├── gitignore_global       # Global gitignore
├── accounts/              # Account-specific configurations
    ├── personal.template  # Template for personal account
    └── work.template      # Template for work account
```

### Conditional Includes:
```
[includeIf "gitdir:~/work/"]
  path = ~/.config/git/accounts/work.gitconfig
```

### 1Password Integration:
- SSH key management
- Git credential helper
- Commit signing

## 7. Testing System

### Validation Commands:
```bash
# Dry run to preview changes
rotz --dry-run link

# Verbose output for debugging
rotz --verbose link

# Validate specific component configurations
rotz --verbose link shells/fish
```

### CI Integration:
```yaml
# .github/workflows/test-install.yml
# Test installation on Ubuntu and macOS
```

### Test Scenarios:
1. Fresh installation
2. Upgrade from previous version
3. Different OS environments (macOS, Linux)
4. Component-specific tests

## 8. Documentation

The repository now includes comprehensive documentation:

1. **README.md**: Overview, features, and quick setup instructions
2. **ROTZ.md**: Detailed guide for using Rotz with this repository
3. **RESTRUCTURING-PLAN.md**: This document, outlining the restructuring approach
4. **Component READMEs**: Documentation in individual component directories
5. **Shell Configuration Guides**: How to customize and extend shell configurations
6. **Troubleshooting Guide**: Common issues and solutions

## Implementation Strategy

### Phase 1: Repository Restructuring (Completed)
- [x] Create new directory structure
- [x] Move existing files to appropriate locations
- [x] Create initial README with new structure documentation
- [x] Adopt Rotz as the dotfile manager
- [x] Move common shell files to shells/common directory

### Phase 2: Core Configuration System (Completed)
- [x] Implement distributed configuration approach with Rotz
- [x] Create dot.yaml files for each component
- [x] Extract common functionality to shells/common directory
- [x] Configure shell-specific installations

### Phase 3: Shell Configuration (Completed)
- [x] Implement Fish shell configuration
- [x] Implement Zsh shell configuration
- [x] Add Bash shell support
- [x] Configure Starship prompt
- [x] Setup plugin management systems

### Phase 4: Additional Components (In Progress)
- [x] Configure editor setups (Vim, Neovim)
- [x] Setup network tools
- [ ] Complete Git configuration
- [x] Simplify package management with direct Brew installations

### Phase 5: Testing and Documentation (In Progress)
- [x] Create basic documentation
- [x] Document Rotz integration
- [ ] Create comprehensive test scripts
- [ ] Add CI testing
- [ ] Create migration guides for existing users

## Migration Strategy

### Backup System
```bash
# Rotz automatically creates backups
rotz link  # Will backup existing files before linking

# Restore backups if needed
rotz restore
```

### Migration from Legacy Structure
```bash
# Initialize Rotz in existing repository
cd ~/.dotfiles
rotz init

# Deploy new structure
rotz link install
```

### Compatibility Considerations
- Rotz allows for gradual migration by component
- Shell configurations maintain compatibility with existing tools
- Core functionality remains consistent across both structures

## Future Enhancements

1. **Additional Shell Support**: Expand support to other shells (PowerShell, nushell)
2. **Enhanced Integration**: Deeper integration with development tools and workflows
3. **Environment Profiles**: Support different profiles (work, personal, server)
4. **Application Configurations**: Add more application-specific configurations
5. **Custom Installation Scripts**: Create specialized installation scripts for complex setups
6. **Documentation Improvements**: More comprehensive guides and examples
7. **Cross-Platform Testing**: Ensure compatibility across more operating systems

## Success Metrics

1. **Installation Time**: Reduce setup time on new machines by 50%
2. **Maintenance Burden**: Reduce time spent maintaining multiple shell configurations
3. **Security**: Zero incidents of sensitive data committed to repository
4. **User Satisfaction**: Improved experience for both personal use and team adoption

## Conclusion

This restructuring plan provides a comprehensive roadmap for transforming the dotfiles repository into a more maintainable, secure, and user-friendly system. By implementing these changes in phases, we can ensure a smooth transition while maintaining functionality throughout the process.

## Next tasks

- [x] Adopt Rotz as the dotfile manager
- [x] Create distributed configuration model
- [x] Setup shell configurations
- [ ] Complete editor configurations
- [ ] Add more application-specific configurations
- [ ] Create comprehensive tests
- [ ] Add CI integration
- [ ] Create specialized installation scripts for complex setups
