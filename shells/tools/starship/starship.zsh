# Load https://starship.rs/ if not in WarpTerminal and not in dumb terminal
# Dumb terminals (TERM=dumb) are used by Cursor Agent and other non-interactive tools
if [[ "${TERM_PROGRAM}" != "WarpTerminal" && "${TERM}" != "dumb" ]]; then
  if command -v starship >/dev/null; then
    eval "$(starship init zsh || true)"
  fi
fi
