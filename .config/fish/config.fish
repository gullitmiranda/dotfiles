set -x LC_ALL en_US.UTF-8

# Install shell integration - https://iterm2.com/documentation-shell-integration.html
if test $TERM_PROGRAM = "iTerm.app" -a -e "$HOME/.iterm2_shell_integration.fish"
    source ~/.iterm2_shell_integration.fish
end

# https://developer.1password.com/docs/cli/shell-plugins/
if type -q op
    source ~/.config/op/plugins.sh
end

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
set --export --prepend PATH "$HOME/.rd/bin"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# Only override docker aliases if rancher desktop is installed, checking if the folder $HOME/.rd/bin and $PATH contains it
if test -d $HOME/.rd/bin; and contains $HOME/.rd/bin $PATH
    alias docker=nerdctl
    alias docker-compose='nerdctl compose'
end

# pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
