# SSH with a temporary tmux session
ssht() {
	ssh -t "$@" "tmux new -A -s main"
}
