# Git completion for aliases
# This file provides completion for git aliases defined in shells/tools/git/aliases.sh

# # Only run in zsh context
# if command -v compdef >/dev/null 2>&1; then
#     # Load git completion more directly
#     if [ -f /opt/homebrew/share/zsh/site-functions/_git ]; then
#         source /opt/homebrew/share/zsh/site-functions/_git
#         echo "Git completion loaded from /opt/homebrew/share/zsh/site-functions/_git"
#     else
#         autoload -Uz _git
#         echo "Git completion loaded via autoload"
#     fi

#     # Check if our functions are defined before registering completion
#     if type ga >/dev/null 2>&1; then
#         # Register completion for each git alias function
#         compdef '_git add' ga
#         compdef '_git branch' gb
#         compdef '_git commit' gc
#         compdef '_git checkout' gco
#         compdef '_git diff' gd
#         compdef '_git fetch' gfap
#         compdef '_git fetch' gfp
#         compdef '_git pull' gl
#         compdef '_git push' gp
#         compdef '_git status' gs
#         compdef '_git' g

#         echo "Git completion registered successfully for aliases"

#         # Debug: show what was registered
#         echo "Registered completions:"
#         echo "  gco -> ${_comps[gco]}"
#         echo "  ga -> ${_comps[ga]}"
#         echo "  gb -> ${_comps[gb]}"
#     else
#         echo "Warning: Git aliases not found. Make sure aliases.sh is loaded before completion.sh"
#     fi
# else
#     echo "Warning: compdef not available (not in zsh context)"
# fi
