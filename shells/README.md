# Shell Configurations

This directory contains configurations for different shells supported by the dotfiles repository.

## Structure

```
shells/
├── fish/            # Fish shell configuration
│   └── config.fish  # Main fish configuration
├── zsh/             # Zsh shell configuration
│   └── .zshrc       # Main zsh configuration
└── README.md        # This file
```

## How It Works

1. The installation script (`tools/install.sh`) creates a minimal shell configuration in your home directory.
2. This minimal configuration sets the `DOTFILES_DIR` environment variable and sources the appropriate shell configuration from this directory.
3. The shell configuration loads modular components from the `core/` directory.

## Requirements

Each shell configuration in this directory **requires** the `DOTFILES_DIR` environment variable to be set. This variable should point to the root of your dotfiles repository. If not set, the shell will display an error message and exit.

## Customization

Add your machine-specific customizations directly to your shell configuration file in your home directory:
- For Fish: `~/.config/fish/config.fish`
- For Zsh: `~/.zshrc`

The installer creates these files with a designated section for your customizations that won't be overwritten when updating the dotfiles repository.

## Adding a New Shell

To add support for a new shell:

1. Create a new directory for your shell (e.g., `shells/bash/`)
2. Add the main configuration file
3. Ensure it checks for `DOTFILES_DIR` and sources the appropriate files from `core/`
4. Update the installation script to support the new shell

## Shell-Specific Notes

### Fish

The Fish configuration disables the greeting message and sets up key bindings, along with various integrations like direnv, starship prompt, iTerm2, and 1Password SSH.

### Zsh

The Zsh configuration sets up history, completion, key bindings, and integrates with direnv, starship prompt, iTerm2, and 1Password SSH.