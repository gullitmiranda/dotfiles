# editor
alias e='${EDITOR}'
alias v='${VISUAL}'
alias c="cursor"
alias cu="cursor"
alias code="cursor"

# cursor profiles
alias cuw="cursor-work"
alias cup="cursor-personal"

# Zed: open in a new workspace.
# A plain alias keeps zed's completions working in zsh/bash, since aliases
# are expanded before completion lookup (so `zedn <TAB>` completes paths
# the same way `zed <TAB>` does).
alias zedn="zed -n"
alias zn="zed -n"
