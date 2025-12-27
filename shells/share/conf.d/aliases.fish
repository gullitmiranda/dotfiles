# Common aliases for Fish shell

# Navigation
alias ~ 'cd ~'
alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../..'
alias cd- 'cd -'

# Directory listing fallback
# Note: eza commands now in eza.fish
if not command -v eza >/dev/null 2>&1
    alias ll 'ls -lah'
    alias la 'ls -A'
end

# System
alias df 'df -h'
alias du 'du -h'
alias free 'free -m'

# Network
alias ip 'ip -c'
alias ports 'netstat -tulanp'

# Fish-specific shortcuts
# alias c clear
alias h history
alias j jobs
alias r 'source $DOTFILES_DIR/shells/fish/config.fish'
alias pathl 'echo $PATH | tr " " "\n"'

# Directory operations
alias md 'mkdir -p'
alias rd rmdir

# Date & time
alias now 'date +"%T"'
alias nowdate 'date +"%d-%m-%Y"'
