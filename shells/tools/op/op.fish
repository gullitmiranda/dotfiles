# 1Password CLI shell integration
# SSH_AUTH_SOCK is NOT set here by default.
# Git auth uses HTTPS via `gh auth git-credential`.
# Commit signing uses local public keys (~/.ssh/signing_*).
#
# To opt-in to the 1Password SSH agent, uncomment below or add to your local config:
#   set -x SSH_AUTH_SOCK ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
