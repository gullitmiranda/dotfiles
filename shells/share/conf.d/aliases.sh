# Common aliases for POSIX shells (bash/zsh)

# Navigation
alias ~='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias cd-='cd -'

# Directory listing fallback
# Note: eza commands now in eza.sh
if ! command -v eza >/dev/null 2>&1; then
	alias ll='ls -lah'
	alias la='ls -A'
fi

# System
alias df='df -h'
alias du='du -h'
alias free='free -m'

# Network
alias ports='netstat -tulanp'

# Shell-specific shortcuts
# alias c='clear'
alias h='history'
alias j='jobs'
alias pathl='echo $PATH | tr ":" "\n"'

# Directory operations
alias md='mkdir -p'
alias rd='rmdir'

# Date & time
alias now='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'

# Devops
alias g=gcloud
