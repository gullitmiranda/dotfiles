# If we have the 1Password CLI, use it to set the SSH_AUTH_SOCK environment variable
# This environment variable is crucial because it allows command-line tools like `ssh-add -l` to locate the SSH agent socket.
if command -v op >/dev/null 2>&1; then
	export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
fi
