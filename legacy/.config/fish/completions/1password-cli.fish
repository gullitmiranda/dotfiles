# https://developer.1password.com/docs/cli/shell-plugins/
if type -q op
  # https://developer.1password.com/docs/cli/reference/commands/completion/#load-shell-completion-information-for-fish
  op completion fish | source
end
