# Load https://starship.rs/ if not in WarpTerminal, not in dumb terminal, and if the starship command exists
# Dumb terminals (TERM=dumb) are used by Cursor Agent and other non-interactive tools
if test "$TERM_PROGRAM" != WarpTerminal && test "$TERM" != dumb && type -q starship
    starship init fish | source
end
