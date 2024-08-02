# set -x LC_ALL en_US.UTF-8

# # Install shell integration - https://iterm2.com/documentation-shell-integration.html
# if test $TERM_PROGRAM = "iTerm.app" -a -e "$HOME/.iterm2_shell_integration.fish"
#     source ~/.iterm2_shell_integration.fish
# end

# https://developer.1password.com/docs/cli/shell-plugins/
if type -q op; and test -e "$HOME/.config/op/plugins.sh"
    source "$HOME/.config/op/plugins.sh"
end

# Add custom alinas to nerdctl and nerdctl compose (alternative to docker and docker-compose)
alias n=nerdctl
alias nc='nerdctl compose'
alias ndocker=nerdctl
alias ndocker-compose='nerdctl compose'

# https://tailscale.com/kb/1080/cli#using-the-cli
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

# https://code.visualstudio.com/docs/terminal/shell-integration#_installation
# WORKAROUND: ⚠️ This is currently experimental and automatic injection is not supported
string match -q "$TERM_PROGRAM" vscode; and source (code --locate-shell-integration-path fish)

# disable homebrew auto update
export HOMEBREW_NO_AUTO_UPDATE=1

# https://krew.sigs.k8s.io/docs/user-guide/setup/install/
set -q KREW_ROOT; and set -gx PATH $PATH $KREW_ROOT/.krew/bin; or set -gx PATH $PATH $HOME/.krew/bin
