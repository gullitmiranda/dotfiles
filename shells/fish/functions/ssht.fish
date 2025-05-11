# SSH with a temporary tmux session
function ssht
    ssh -t $argv "tmux new -A -s main"
end
