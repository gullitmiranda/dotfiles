# Git aliases with completion support
# Completion is configured in shells/tools/git/completion/git.sh

# Use functions instead of aliases for better completion support
ga() { git add "$@"; }
gb() { git branch "$@"; }
gc() { git commit "$@"; }
gco() { git checkout "$@"; }
gd() { git diff "$@"; }
gfap() { git fetch --all --prune "$@"; }
gfp() { git fetch --prune "$@"; }
gl() { git pull "$@"; }
gp() { git push "$@"; }
gs() { git status "$@"; }

# Create alias 'g' for backward compatibility
alias g='git'
