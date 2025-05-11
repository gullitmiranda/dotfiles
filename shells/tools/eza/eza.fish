# Setup eza (modern ls replacement)
# ----------

if command -v eza >/dev/null 2>&1
    # Replace ls with eza
    alias ls eza
    alias ll 'eza -l'
    alias la 'eza -la'
    alias lt 'eza --tree'
    alias llt 'eza -l --tree'
    alias tree 'eza --tree'

    # Sort aliases
    alias lss 'eza -s size' # Sort by size
    alias lst 'eza -s mod' # Sort by modification time
    alias lsn 'eza -s name' # Sort by name (default)
    alias lse 'eza -s ext' # Sort by extension

    # Display options
    alias lsg 'eza --git' # Show git status
    alias lsi 'eza --icons' # Show icons
    alias lsc 'eza --color=always'

    # Combined options for common use cases
    alias lsa 'eza -la --git --icons --color=always' # Show everything with git and icons
    alias l 'eza -la --git --icons --color=always' # Shorthand

    # Grid and other formatting
    alias lsgrid 'eza --grid'
    alias lslong 'eza -l --header --icons --git'

    # File type specific
    alias lsd 'eza -D' # Only directories
    alias lsf 'eza --only-files' # Only files

    # Extended view
    alias lsx 'eza -lbhHigUmuSa' # Show extended details
end
