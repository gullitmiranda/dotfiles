# Enable debugging if DEBUG_ZSHRC is set
if [[ -n "$DEBUG_ZSHRC" ]]; then
    SHELL_DEBUG_FILE=$HOME/.shell.debug
    now=$(date +%Y-%m-%dT%H:%M:%S%z)

    echo -e "\n\n" >>$SHELL_DEBUG_FILE
    echo ".zshrc $now" >>$SHELL_DEBUG_FILE

    echo "env:" >>$SHELL_DEBUG_FILE
    env >>$SHELL_DEBUG_FILE
    echo -e "----\n" >>$SHELL_DEBUG_FILE
fi

# # enable GPG without GPG Suite - https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key
# export GPG_TTY=$(tty)

# # Install shell integration - https://iterm2.com/documentation-shell-integration.html
# test $TERM_PROGRAM = "iTerm.app" -a -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true

# [ -f ~/.zprofile ] && source ~/.zprofile
# [ -f ~/.profile ] && source ~/.profile
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# # runs only for interactive sessions - https://mise.jdx.dev/dev-tools/shims.html#zshrc-bashrc-files
# # it will override the shims from paths
# eval "$(mise activate zsh)"
# eval "$(mise hook-env -s zsh)"

# # https://code.visualstudio.com/docs/terminal/shell-integration#_installation
# # WORKAROUND: ⚠️ This is currently experimental and automatic injection is not supported
# [[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

# Example of error handling
some_command() {
    if ! command_to_run; then
        echo "Error: command_to_run failed" >>$SHELL_DEBUG_FILE
    fi
}

if [[ -n "$DEBUG_ZSHRC" ]]; then
    echo -e "\n" >>$SHELL_DEBUG_FILE
    echo ".zshrc END $now" >>$SHELL_DEBUG_FILE

    echo "env:" >>$SHELL_DEBUG_FILE
    env >>$SHELL_DEBUG_FILE
    echo -e "----\n" >>$SHELL_DEBUG_FILE
fi

# # Automatically "Warpify" subshells
# # https://docs.warp.dev/features/subshells
# if [[ "$TERM_PROGRAM" == "WarpTerminal" ]]; then
#     printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "zsh"}}\x9c'
# fi

[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
