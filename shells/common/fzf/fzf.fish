# Setup fzf

if not string match -q "*opt/homebrew/opt/fzf/bin*" $PATH
  set -gx PATH $PATH /opt/homebrew/opt/fzf/bin
end

# Key bindings
source "/opt/homebrew/opt/fzf/shell/key-bindings.fish"

# FZF customization
set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -gx FZF_ALT_C_COMMAND "fd --type d --hidden --follow --exclude .git"
set -gx FZF_DEFAULT_OPTS "--height 40% --layout=reverse --border"

# Use fd instead of find for fzf
function fzf_configure_using_fd --description 'Configure fzf to use fd'
  set -l fd_command 'fd --hidden --follow --exclude .git'
  set -gx FZF_CTRL_T_COMMAND "$fd_command --type f"
  set -gx FZF_ALT_C_COMMAND "$fd_command --type d"
end
fzf_configure_using_fd