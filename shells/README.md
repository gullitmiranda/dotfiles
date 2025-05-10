# Shell Configurations

This directory contains configurations for different shells supported by the dotfiles repository.

## Structure

```
shells/
├── fish/            # Fish shell configuration
│   ├── config.fish  # Main fish configuration
│   └── fish_plugins # Fisher plugins list
├── zsh/             # Zsh shell configuration
│   ├── .zshrc       # Main zsh configuration
│   └── zsh_plugins  # Zinit plugins list
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

## Plugin Management

This dotfiles repository uses a simple and consistent approach to plugin management:

### Fish Shell Plugins

1. **Plugin List:**

   - Plugin examples are provided in `fish/fish_plugins` (as comments)
   - Uncomment or add plugin URLs when you want to use them
   - Each plugin is listed on a separate line with its GitHub repository URL

2. **Installation:**

   - Fisher is automatically installed during dotfiles setup
   - The `fish_plugins` file is symlinked to `~/.config/fish/fish_plugins`
   - Plugins will be installed when you uncomment or add them and run `fisher update`
   - Plugin files are stored outside the repository in standard Fisher directories

3. **Management:**
   - To update plugins: `fisher update`
   - To list plugins: `fisher list`
   - To add a plugin: either edit `fish_plugins` and run `fisher update`, or use `fisher add <plugin-url>`
   - To remove a plugin: either edit `fish_plugins` and run `fisher update`, or use `fisher remove <plugin-name>`

### Zsh Shell Plugins

1. **Plugin List:**

   - Plugin examples are provided in `zsh/zsh_plugins` (as comments)
   - Uncomment or add plugins when you want to use them
   - Each plugin is defined with a Zinit command (e.g., `zinit light author/repo`)

2. **Installation:**

   - Zinit is automatically installed during dotfiles setup
   - Uncomment plugins in the format that Zinit understands
   - When the shell starts, Zinit will load any active plugins from `zsh_plugins`
   - Plugin files are stored outside the repository in `~/.local/share/zinit/`

3. **Management:**
   - To update Zinit plugins: `zinit update --all`
   - To add a plugin: add its URL to `zsh_plugins`
   - Plugins are automatically loaded when you start your shell

## Shell-Specific Notes

### Fish

The minimal Fish configuration includes:

- Disabled greeting message for a cleaner startup
- Emacs-style key bindings by default
- Intelligent editor selection (nvim > vim > nano)
- Fisher plugin management capabilities
- Modular loading of environment, paths, aliases, and functions

Additional features can be added in your local configuration or by enabling plugins.

### Zsh

The minimal Zsh configuration includes:

- Basic history management with deduplication and sharing
- Simple tab completion with menu selection
- Intelligent editor selection (nvim > vim > nano)
- Zinit plugin management capabilities
- Modular loading of environment, paths, aliases, and functions

Additional features can be added in your local configuration or by enabling plugins.
