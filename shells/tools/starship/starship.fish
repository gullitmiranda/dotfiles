# Load https://starship.rs/ if not in WarpTerminal and if the starship command exists
if test "$TERM_PROGRAM" != WarpTerminal && type -q starship
    starship init fish | source
end
