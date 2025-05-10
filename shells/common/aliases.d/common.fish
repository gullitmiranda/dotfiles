# Common aliases for Fish shell

# Navigation
alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../..'

# Directory listing fallback
# Note: eza commands now in eza.fish
if not command -v eza >/dev/null 2>&1
    alias ll 'ls -lah'
    alias la 'ls -A'
end

# Git shortcuts
alias g git
alias gs 'git status'
alias gd 'git diff'
alias gl 'git log'
alias ga 'git add'
alias gc 'git commit'
alias gp 'git push'
alias gb 'git branch'
alias gco 'git checkout'

# System
alias df 'df -h'
alias du 'du -h'
alias free 'free -m'

# Network
alias ip 'ip -c'
alias ports 'netstat -tulanp'

# Fish-specific shortcuts
alias c clear
alias h history
alias j jobs
alias r 'source $DOTFILES_DIR/shells/fish/config.fish'
alias path 'echo $PATH | tr " " "\n"'

# Directory operations
alias md 'mkdir -p'
alias rd rmdir

# Date & time
alias now 'date +"%T"'
alias nowdate 'date +"%d-%m-%Y"'
