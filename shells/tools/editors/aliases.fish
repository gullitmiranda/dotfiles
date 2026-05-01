# Editor aliases
alias e '$EDITOR'
alias v '$VISUAL'
alias c 'cursor'
alias code cursor

# Cursor profiles
alias cuw cursor-work
alias cup cursor-personal

# Zed: open in a new workspace.
# Defined as a function (instead of `alias`) so we can use `--wraps=zed`,
# which makes fish reuse zed's completions (paths, flags, etc.).
function zedn --wraps=zed --description 'zed -n: open in a new workspace'
    command zed -n $argv
end
