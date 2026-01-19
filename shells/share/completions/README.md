# Shared Shell Completions

This directory contains completion scripts that are shared across all shells (bash, zsh, fish).

## Structure

Tool-specific completions should be placed in their respective tool directories under `shells/tools/<tool>/completions/`. This directory is for completions that don't belong to a specific tool.

## Current Completions

### gcloud.sh

Google Cloud SDK completion loader. Automatically sources gcloud completions when:
- `mise` is available
- gcloud is installed via mise

## Adding New Completions

1. For tool-specific completions: add to `shells/tools/<tool>/completions/`
2. For shared/generic completions: add to this directory

Use POSIX-compatible syntax (`.sh` extension) for cross-shell compatibility, or create shell-specific files (`.bash`, `.zsh`, `.fish`).

## Loading Behavior

- **Zsh/Bash**: Files are sourced at shell startup
- **Fish**: Completions are autoloaded via `$fish_complete_path`
