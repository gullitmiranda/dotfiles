# Common aliases for POSIX shells (bash/zsh)

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Directory listing fallback
# Note: eza commands now in eza.sh
if ! command -v eza >/dev/null 2>&1; then
	alias ll='ls -lah'
	alias la='ls -A'
fi

# Git shortcuts
alias g='git'
alias gs='git status'
alias gd='git diff'
alias gl='git log'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gb='git branch'
alias gco='git checkout'

# System
alias df='df -h'
alias du='du -h'
alias free='free -m'

# Network
alias ports='netstat -tulanp'

# Shell-specific shortcuts
alias c='clear'
alias h='history'
alias j='jobs'
alias pathl='echo $PATH | tr ":" "\n"'

# Directory operations
alias md='mkdir -p'
alias rd='rmdir'

# Date & time
alias now='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'

# editor
alias e='${EDITOR}'
alias v='${VISUAL}'
alias c="cursor"
alias code="cursor"
