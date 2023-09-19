# # enable GPG without GPG Suite - https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key
# export GPG_TTY=$(tty)

# Install shell integration - https://iterm2.com/documentation-shell-integration.html
test $TERM_PROGRAM = "iTerm.app" -a -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true

[ -f ~/.profile ] && source ~/.profile
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
