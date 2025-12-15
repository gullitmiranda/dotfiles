# https://developer.1password.com/docs/cli
if command -v op >/dev/null 2>&1; then
  # https://developer.1password.com/docs/cli/reference/commands/completion/#load-shell-completion-information-for-bash
  source <(op completion bash)
fi
