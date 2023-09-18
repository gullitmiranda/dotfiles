set -x LC_ALL en_US.UTF-8

# Install shell integration - https://iterm2.com/documentation-shell-integration.html
if test $TERM_PROGRAM = "iTerm.app" -a -e "$HOME/.iterm2_shell_integration.fish"
    source ~/.iterm2_shell_integration.fish
end

