# Setup fzf

if not command -v fzf >/dev/null 2>&1
    return 0
end

# Set up fzf key bindings
fzf --fish | source

# FZF customization
# ----------------
# See https://github.com/junegunn/fzf#environment-variables
#
# cycle allows jumping between the first and last results, making scrolling faster
# layout=reverse lists results top to bottom, mimicking the familiar layouts of git log, history, and env
# border shows where the fzf window begins and ends
# height=90% leaves space to see the current command and some scrollback, maintaining context of work
# preview-window=wrap wraps long lines in the preview window, making reading easier
# marker=* makes the multi-select marker more distinguishable from the pointer (since both default to >)
set -gx FZF_DEFAULT_OPTS '--cycle --layout=reverse --border --height=90% --preview-window=wrap --marker="*"'

# Set up fzf to use fd (https://github.com/sharkdp/fd)
if command -v fd >/dev/null 2>&1
    set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
    set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
    set -gx FZF_ALT_C_COMMAND "fd --type d --hidden --follow --exclude .git"
end

# Preview file content using bat (https://github.com/sharkdp/bat)
# CTRL-Y to copy the file content to clipboard
# CTRL-P to copy the file path to clipboard
# CTRL-? to change the preview
if command -v bat >/dev/null 2>&1
    set -gx FZF_CTRL_T_OPTS "
        --walker-skip .git,node_modules,target
        --preview 'bat -n --color=always {}'
        --preview-window hidden
        --bind 'ctrl-/:change-preview-window(right|down|hidden|)'
        --bind 'ctrl-y:execute-silent(cat {} | pbcopy)+abort'
        --bind 'ctrl-p:execute-silent(echo {} | pbcopy)'
        --color header:italic
        --header 'Preview: `CTRL-/`, Copy: `CTRL-Y`, Copy Path: `CTRL-P`'"
end

# Check for pbcopy command and set FZF_CTRL_R_OPTS if available
if command -v pbcopy >/dev/null 2>&1
    set -gx FZF_CTRL_R_OPTS "
        --preview 'echo {}'
        --preview-window down:3:hidden:wrap
        --bind 'ctrl-/:change-preview-window(down|hidden|)'
        --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
        --color header:italic
        --header 'Preview: `CTRL-/`, Copy: `CTRL-Y`'"
end

# Check for eza command and set FZF_ALT_C_OPTS if available
if command -v eza >/dev/null 2>&1
    set -gx FZF_ALT_C_OPTS "
        --walker-skip .git,node_modules,target
        --preview 'eza --tree {} | head -200'"
end

# Setting up PatrickF1/fzf.fish custom key bindings
# ----------------
# https://github.com/PatrickF1/fzf.fish/blob/main/README.md#customize-key-bindings
#
# For more information, run:
#   fzf_configure_bindings --help

if functions -q fzf_configure_bindings >/dev/null 2>&1
    # \e represents the escape character in fish shell.
    # NOTE:
    # For macOS users with iTerm: To enable the `alt` key functionality, configure the terminal to send `Esc+` when `alt` is pressed.
    #   - Navigate to Preferences > Profiles > Keyboard > Modifier Keys and set Alt to Esc+.
    fzf_configure_bindings --directory=\ef --git_log=\el --git_status=\es --processes=\ep --history=\eh --variables=\ev
end
