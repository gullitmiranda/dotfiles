# Load https://starship.rs/ if not in WarpTerminal
if [[ ${TERM_PROGRAM} != "WarpTerminal" ]]; then
	if command -v starship >/dev/null; then
		eval "$(starship init bash || true)"
	fi
fi
