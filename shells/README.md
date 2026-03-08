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
├── bash/            # Bash shell configuration
│   ├── .bashrc      # Main bash configuration
│   ├── functions/   # Bash functions
│   ├── conf.d/      # Bash configuration snippets
│   └── completions/ # Bash completions
├── share/           # Shared configurations
│   ├── completion/  # Shared completions
│   ├── functions/   # Shared functions
│   └── conf.d/      # Shared configuration snippets
├── tools/           # Tools and utilities terminal configurations
│   ├── starship/    # Starship prompt configuration
│   ├── editors/     # Editor configurations
│   ├── ripgrep/     # Ripgrep configurations
│   ├── bat/         # Bat configurations
│   ├── eza/         # Eza configurations
│   ├── fd/          # FD configurations
│   ├── fzf/         # FZF configurations
│   └── op/          # 1Password CLI configurations
│       └── completions/ # 1Password CLI completions
└── README.md        # This file
```

## How It Works

1. The installation script (`rotz link shells/* && rotz install shells/*`) creates a minimal shell configuration in your home directory.
2. This minimal configuration sets the `DOTFILES_DIR` environment variable and sources the appropriate shell configuration from this directory.
3. The shell configuration loads modular components from the `tools/` and `share/` directories.

## Requirements

Each shell configuration in this directory **requires** the `DOTFILES_DIR` environment variable to be set. This variable should point to the root of your dotfiles repository. If not set, the shell will display an error message and exit.

## Customization

> [!IMPORTANT]
> Be careful when adding `.{sh,bash,zsh,fish}` files inside this `shells/` folder and subfolders as they may be autoloaded. See section [Shell Initialization and Standardization](#shell-initialization-and-standardization) for more details.

To make your own customizations, you can either:

- Add your machine-specific customizations directly to your shell configuration file in your home directory:
  - For Fish: `~/.config/fish/config.fish`
  - For Zsh: `~/.zshrc`
  - For Bash: `~/.bashrc`

  > The installer creates or updates these files with a designated section to load the dotfiles, so you can add your customizations without losing them when updating the dotfiles repository.

- Or, changing the files in this repository:
  - For Fish: `shells/fish/config.fish`
  - For Zsh: `shells/zsh/.zshrc`
  - For Bash: `shells/bash/.bashrc`
  - Or files in the `shells/tools/` and `shells/share/` directories

  > Which can be overwritten when updating the dotfiles repository, if not committed to the repository.

## Shell Initialization and Standardization

The dotfiles shell configuration files are designed to be modular and loaded in a specific order.

1. The `shells/tools/` directory contains the core tools and utilities, and their shell-specific configurations, completions, and functions.
2. The `shells/share/` directory contains shared configurations, including completions, functions, and configuration snippets.
3. The `shells/$SHELL/` directories contain the shell-specific configuration files.

> NOTE: `fish` only loads the completions and functions as needed, so instead of sourcing on startup we've configured the `$fish_function_path` and `$fish_complete_path` variables.

So any of these folders can have files named like `*.{sh,bash,zsh,fish}` and they will be loaded automatically based on the shell.
Except for `fish` which will load the `tools/**/completions` and `share/**/completions` as needed.

> It's recommended that you restart your shell after adding new files or folders to ensure they are loaded. To do that you can run `exec $SHELL`.

### Non-Shell Folders

#### Shared Configurations

The `share/` directory contains shared configuration snippets, functions, and completions that are used across all shells.

Subdirectories:

- `conf.d/` Configuration snippets (e.g., environment variables, aliases) loaded at shell startup.
- `functions/` Shell functions (sourced at startup for Zsh/Bash; autoloaded on demand for Fish).
- `completions/` Completion scripts (sourced at startup for Zsh/Bash; autoloaded on demand for Fish).

Each shell processes these files differently:

- **Fish**: loads `*.fish` in `conf.d/` at startup; functions and completions autoloaded via `$fish_function_path` and `$fish_complete_path`.
- **Zsh**: sources all `*.{zsh,sh}` files in `conf.d/`, `functions/`, and `completions/` at startup.
- **Bash**: sources all `*.{bash,sh}` files in `conf.d/`, `functions/`, and `completions/` at startup.

Benefits of shared configurations:

- **Consistency**: Same aliases, functions, and variables across shells.
- **Maintainability**: One place to update common settings.
- **Organization**: Logical separation of configuration types.

> **Note:** When adding new files, use POSIX-compatible syntax wherever possible to ensure compatibility across all shells.

#### Tools and Utilities

The `tools/` directory contains tool-specific shell integrations and configurations that enhance how various command-line utilities behave in your shell.

Subdirectories:

- `starship/` Starship prompt configuration
- `editors/` Editor environment and keybinding management
- `ripgrep/` Ripgrep default flags and shell completions
- `bat/` Bat configuration and themes
- `eza/` Eza output and table formatting
- `fd/` FD default options and aliases
- `fzf/` FZF keybindings and integration scripts
- `op/` 1Password CLI configurations and completions

Each tool directory may include:

- `completions/` Completion scripts sourced at startup (Zsh/Bash) or autoloaded on demand (Fish).
- `functions/` Wrapper functions or helper scripts.
- `*.sh`, `*.zsh`, `*.fish` Shell-specific configuration snippets loaded during initialization.

Loading behavior:

- **Fish**: autoloads functions and completions via `$fish_function_path` and `$fish_complete_path`.
- **Zsh/Bash**: sources all shell-specific files (`*.sh`, `*.zsh`, `*.bash`) at startup.

Benefits of tool integrations:

- **Consistency**: Uniform tool behavior across shells.
- **Maintainability**: Centralized management of tool settings.
- **Organization**: Logical grouping of tool configurations.

> **Note:** When adding new tool directories, name them after the tool and include the appropriate shell-specific files to ensure automatic loading.

## Plugin Management

This dotfiles repository uses a simple and consistent approach to plugin management:

### Fish Shell Plugins

1. **Plugin List:**
   - Plugin examples are provided in `shells/fish/fish_plugins` (as comments)
   - Uncomment or add plugin URLs when you want to use them
   - Each plugin is listed on a separate line with its GitHub repository URL

2. **Installation:**
   - Fisher is automatically installed during dotfiles setup
   - The `shells/fish/fish_plugins` file is symlinked to `~/.config/fish/fish_plugins`
   - Plugins will be installed when you uncomment or add them and run `fisher update`
   - Plugin files are stored outside the repository in standard Fisher directories

3. **Management:**
   - To update plugins: `fisher update`
   - To list plugins: `fisher list`
   - To add a plugin: either edit `shells/fish/fish_plugins` and run `fisher update`, or use `fisher add <plugin-url>`
   - To remove a plugin: either edit `shells/fish/fish_plugins` and run `fisher update`, or use `fisher remove <plugin-name>`

### Zsh Shell Plugins

1. **Plugin List:**
   - Plugin examples are provided in `shells/zsh/zsh_plugins` (as comments)
   - Uncomment or add plugins when you want to use them
   - Each plugin is defined with a Zinit command (e.g., `zinit light author/repo`)

2. **Installation:**
   - Zinit is automatically installed during dotfiles setup
   - Uncomment plugins in the format that Zinit understands
   - When the shell starts, Zinit will load any active plugins from `shells/zsh/zsh_plugins`
   - Plugin files are stored outside the repository in `~/.local/share/zinit/`

3. **Management:**
   - To update Zinit plugins: `zinit update --all`
   - To add a plugin: add its URL to `shells/zsh/zsh_plugins`
   - Plugins are automatically loaded when you start your shell

## Adding a New Shell

To add support for a new shell:

1. Create a new directory for your shell (e.g., `shells/elvish/`)
2. Add the `dot.yaml` with the links and install commands for the shell
3. Add the main configuration file (e.g., `shells/elvish/.elvishrc`)
4. Ensure it checks for `DOTFILES_DIR` and sources the appropriate files from `tools/` and `share/`
5. Update the installation script to support the new shell

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

### Bash

The `bash/` directory contains the main configuration file `.bashrc`, along with directories for functions, configuration snippets, and completions. This setup allows for modular and organized Bash configurations.
