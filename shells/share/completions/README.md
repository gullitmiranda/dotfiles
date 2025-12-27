# Shell Completions

This directory contains completion configurations for various tools and aliases.

## Git Aliases Completion

Git completion is configured in `shells/tools/git/completion/git.sh` and works with the aliases defined in `shells/tools/git/aliases.sh`.

### How it works

1. **Function-based aliases**: The git aliases are defined as functions in `shells/tools/git/aliases.sh`
2. **Completion registration**: Completion is registered in `shells/tools/git/completion/git.sh` using `compdef`
3. **Co-located configuration**: Aliases and completion are in the same directory for better organization
4. **Automatic loading**: Both files are automatically sourced by the main zsh configuration

### Available completions

- `g` → `_git` (alias for general git completion)
- `ga` → `_git add` (git add completion)
- `gb` → `_git branch` (git branch completion)
- `gc` → `_git commit` (git commit completion)
- `gco` → `_git checkout` (git checkout completion)
- `gd` → `_git diff` (git diff completion)
- `gfap` → `_git fetch` (git fetch completion)
- `gfp` → `_git fetch` (git fetch completion)
- `gl` → `_git pull` (git pull completion)
- `gp` → `_git push` (git push completion)
- `gs` → `_git status` (git status completion)

### Usage

After the configuration is loaded, you can use tab completion with any of the git aliases:

```bash
# Example: Type 'gc' and press Tab to see commit options
gc <Tab>

# Example: Type 'gb' and press Tab to see branch options
gb <Tab>

# Example: Type 'gco' and press Tab to see checkout options
gco <Tab>

# Example: Type 'g' and press Tab to see general git options
g <Tab>
```

### Troubleshooting

If completion doesn't work:

1. Ensure both files are being sourced (check `shells/zsh/.zshrc`)
2. Verify that git completion is available (`which _git`)
3. Restart your shell or run `source ~/.zshrc`
4. Check that the functions are properly defined (`type ga`)

### Adding new git aliases

To add a new git alias with completion:

1. Add the function to `shells/tools/git/aliases.sh`
2. Add the completion registration to `shells/tools/git/completion/git.sh`
3. Test the function definition

### Technical notes

- **Why functions instead of aliases?** The `compdef` command only works with functions, not aliases
- **Co-located configuration**: Aliases and completion are in the same directory for better organization
- **Completion registration**: Each function is mapped to its corresponding git completion function for precise completion
- **Safe registration**: Completion is only registered if `compdef` is available (zsh context)
