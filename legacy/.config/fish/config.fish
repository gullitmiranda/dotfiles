# set -x LC_ALL en_US.UTF-8

# # Install shell integration - https://iterm2.com/documentation-shell-integration.html
# if test $TERM_PROGRAM = "iTerm.app" -a -e "$HOME/.iterm2_shell_integration.fish"
#     source ~/.iterm2_shell_integration.fish
# end

set -gx SHELL_DEBUG_FILE ~/.local/var/log/fish-debug.log
mkdir -p (dirname $SHELL_DEBUG_FILE)
function fish_debug_log
    # echo -e $argv >> $SHELL_DEBUG_FILE
    printf '%s\n' $argv >> $SHELL_DEBUG_FILE
end

# Activating mise
# set -gx __MISE_INTERACTIVE (test -q (status is-interactive); and echo true; or echo false)
if status is-interactive
  set -gx __MISE_INTERACTIVE true
else
  set -gx __MISE_INTERACTIVE false
end

fish_debug_log ""
fish_debug_log "<<< mise activation start (interactive: $__MISE_INTERACTIVE)"
fish_debug_log "PATH: $PATH"
fish_debug_log "__MISE_ORIG_PATH: $__MISE_ORIG_PATH"
fish_debug_log ""

# https://github.com/jdx/mise/issues/2270#issuecomment-2211805443
if test "$VSCODE_RESOLVING_ENVIRONMENT" = 1
  fish_debug_log "+ mise activate fish --shims (VSCODE_RESOLVING_ENVIRONMENT)"
  fish_debug_log (mise activate fish --shims)
  mise activate fish --shims | source
else if status is-interactive
  fish_debug_log "+ mise activate fish"
  fish_debug_log (mise activate fish)
  mise activate fish | source

  fish_debug_log "+ mise hook-env -s fish"
  fish_debug_log (mise hook-env -s fish)
  mise hook-env -s fish | source
else
  fish_debug_log "+ mise activate fish --shims"
  fish_debug_log (mise activate fish --shims)
  mise activate fish --shims | source
end

fish_debug_log "=== mise activated (interactive: $__MISE_INTERACTIVE)"
fish_debug_log "PATH: $PATH"
fish_debug_log "__MISE_ORIG_PATH: $__MISE_ORIG_PATH"
fish_debug_log ">>> mise activation end"
fish_debug_log ""

# # Automatically "Warpify" subshells
# # https://docs.warp.dev/features/subshells
# if status is-interactive; and test "$TERM_PROGRAM" = "WarpTerminal"
#   printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "fish"}}\x9c'
# end

fish_debug_log "<<< direnv status"
fish_debug_log (direnv status)
fish_debug_log ">>> direnv status"
