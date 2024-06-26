set -x LC_ALL en_US.UTF-8

# Install shell integration - https://iterm2.com/documentation-shell-integration.html
if test $TERM_PROGRAM = "iTerm.app" -a -e "$HOME/.iterm2_shell_integration.fish"
    source ~/.iterm2_shell_integration.fish
end

# https://medium.com/@msvechla/customizing-the-new-iterm2-status-bar-to-your-needs-252eee06bf39
function iterm2_print_user_vars
    # Preferences >Profiles > Session > Configure Status Bar > Interpolated String
    # - String Value: arch=\(user.TERM_ARCH)
    iterm2_set_user_var TERM_ARCH (arch)
end

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

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
set --export --prepend PATH "$HOME/.rd/bin"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# customize docker host for https://github.com/abiosoft/colima or rancher desktop
export DOCKER_HOST=unix://$HOME/.colima/default/docker.sock
# export DOCKER_HOST=unix://$HOME/.rd/docker.sock
