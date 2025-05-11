# Command Shared files between shells

This directory contains files that are shared between shells, providing a unified configuration approach.

- `conf.d` - Configuration files for shells
- `functions` - Functions for shells
- `completions` - Completions for shells

## How It Works

Each shell's configuration sources these shared files using shell-specific syntax. This approach provides:

1. **Consistency**: The same aliases, functions, and environment variables across all shells.
2. **Maintainability**: Update configurations in one place instead of for each shell.
3. **Organization**: Logical separation of different types of configurations.

## Fish

Fish will load all `*.fish` files in the directory:

- `conf.d` directory on startup
- `functions` directory on demand
- `completions` directory on demand

## Zsh

Zsh will load all `*.{zsh,sh}` files in the directory:

- `conf.d` directory on startup
- `functions` directory on startup
- `completions` directory on startup

## Bash

Bash will load all `*.{bash,sh}` files in the directory:

- `conf.d` directory on startup
- `functions` directory on startup
- `completions` directory on startup

## Note on Syntax

When adding new files, use POSIX-compatible syntax wherever possible to ensure compatibility with all shells. Shell-specific adaptations are handled in each shell's configuration files.
