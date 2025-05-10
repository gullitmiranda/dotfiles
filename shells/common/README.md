# Common Shell Configurations

This directory contains shell-agnostic configurations that are shared across all supported shells (Fish, Zsh, and Bash).

## Directory Structure

```
common/
├── aliases.d/   # Shared aliases organized by category
├── env.d/       # Shared environment variables
├── functions.d/ # Shared functions
└── paths.d/     # Shared PATH additions
```

## How It Works

Each shell's configuration will source these shared files using shell-specific syntax. This approach provides:

1. **Consistency**: The same aliases, functions, and environment variables across all shells
2. **Maintainability**: Update configurations in one place instead of for each shell
3. **Organization**: Logical separation of different types of configurations

## Usage

### Adding New Aliases

Create a new file in `aliases.d/` with a descriptive name (e.g., `git.sh` for Git aliases):

```bash
# aliases.d/git.sh
# Git aliases
alias g='git'
alias gs='git status'
alias gc='git commit'
```

### Adding Environment Variables

Create a new file in `env.d/` with a descriptive name:

```bash
# env.d/java.sh
# Java environment variables
export JAVA_HOME="/usr/lib/jvm/default-java"
```

### Adding Functions

Create a new file in `functions.d/` with a descriptive name:

```bash
# functions.d/utils.sh
# Utility functions
mkcd() {
  mkdir -p "$1" && cd "$1"
}
```

### Adding PATH Extensions

Create a new file in `paths.d/` with a descriptive name:

```bash
# paths.d/rust.sh
# Rust PATH additions
export PATH="$HOME/.cargo/bin:$PATH"
```

## Implementation in Shell Configurations

Each shell implements its own mechanism to source these common files:

- **Fish**: Uses special syntax to set environment variables and define functions
- **Zsh**: Sources these files directly with standard shell syntax
- **Bash**: Similar to Zsh, sources these files using standard syntax

## Note on Syntax

When adding new files, use POSIX-compatible syntax wherever possible to ensure compatibility with all shells. Shell-specific adaptations are handled in each shell's configuration files.
