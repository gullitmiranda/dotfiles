# Git completion for aliases
# This file provides completion for git aliases defined in shells/tools/git/aliases.sh

# Only run in zsh context
if command -v compdef >/dev/null 2>&1; then
    # Load git completion if not already loaded
    autoload -Uz _git
    
    # Register completion for each git alias function
    compdef '_git add' ga
    compdef '_git branch' gb
    compdef '_git commit' gc
    compdef '_git checkout' gco
    compdef '_git diff' gd
    compdef '_git fetch' gfap
    compdef '_git fetch' gfp
    compdef '_git pull' gl
    compdef '_git push' gp
    compdef '_git status' gs
    compdef '_git' g
fi
