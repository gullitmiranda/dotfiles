[ -f ~/.profile ] && source ~/.profile
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# https://cloud.google.com/iap/docs/using-tcp-forwarding#increasing_the_tcp_upload_bandwidth
export CLOUDSDK_PYTHON_SITEPACKAGES=1

# https://code.visualstudio.com/docs/terminal/shell-integration#_installation
# WORKAROUND: ⚠️ This is currently experimental and automatic injection is not supported
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path bash)"

# # Automatically "Warpify" subshells
# # https://docs.warp.dev/features/subshells
# if [[ "$TERM_PROGRAM" == "WarpTerminal" ]]; then
#     printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "bash" }}\x9c'
# fi
