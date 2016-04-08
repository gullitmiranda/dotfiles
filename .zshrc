# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="agnoster"
# ZSH_THEME="cobalt2"
# ZSH_THEME="amuse"
ZSH_THEME="powerlevel9k"

# USER="gullitmiranda"
DEFAULT_USER="gullitmiranda"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(longstatus history time)
POWERLEVEL9K_PROMPT_ON_NEWLINE=true

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(common-aliases coreutils dirpersist bundler docker gem git git-extras myalias git-hubflow git-flow sublime zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# User configuration
# http://zsh.sourceforge.net/Intro/intro_16.html
setopt correct
setopt cdablevars
setopt interactivecomments

# https://robots.thoughtbot.com/cding-to-frequently-used-directories-in-zsh
setopt auto_cd
cdpath=($HOME/Works $HOME/Works/request $HOME)

export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:$ZSH/bin:$PATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias zshrc='subl ~/.zshrc'

if [ -f "/usr/local/bin/exa" ]; then
  alias la='exa -abghHliS'
fi

bindkey -e

# Arrow search
bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward
bindkey '^[OA' history-beginning-search-backward
bindkey '^[OB' history-beginning-search-forward
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward

# Mac OSX
if [[ "$OSTYPE" == "darwin"* ]]; then
  # Word Jump
  bindkey '^[[1;9C' forward-word
  bindkey '^[[1;9D' backward-word

  # Line limits jumping
  bindkey '\033f' beginning-of-line
  bindkey '\033e' end-of-line
  # bindkey "\e[1~" beginning-of-line
  # bindkey "\e[4~" end-of-line

  # Git GUI interface
  alias sourcetree='open -a SourceTree'
  alias tower='open -a Tower'
  # short
  alias st='sourcetree .'
  alias stree='sourcetree'
  alias tw='tower .'
  alias ccat='pygmentize'

  alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
  alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
fi

# Alias
alias hgrep='history | grep'
alias pgrep='ps aux | grep -v grep | grep'
alias egrep='env | grep'
alias agrep='alias | grep'

alias ss='subl .'
alias ssp='subl $(basename "$PWD").sublime-project'
alias atodo='subl ~/Works/azuki/TODO'
alias ptodo='subl ~/Documents/Personal.todo'

# alias wh='while; do $arg; done'

# azk
if [ -d "$HOME/.local/bin" ]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "/opt/local/bin" ]; then
  export PATH="$PATH:/opt/local/bin"
fi

if [ -d "$HOME/Works/azuki/azk/bin" ]; then
  export AZK_SOURCE_PATH="$HOME/Works/azuki/azk"
  export PATH="${AZK_SOURCE_PATH}/bin:$PATH"
  alias a="${AZK_SOURCE_PATH}/bin/azk"
  alias azk="${AZK_SOURCE_PATH}/bin/azk"
  alias docker="${AZK_SOURCE_PATH}/bin/adocker"
  alias anvm='a nvm'
  alias anode='anvm node'

  # alias nvm='anvm'
  # alias anpm='anvm npm'
  # alias npm='anpm'

  # alias node='anode'
  # alias gulp='agulp'

  export AZK_ENV=development
  export AZK_VM_MEMORY=512
  export AZK_AGENT_CHECK_INTERVAL=30000
  export AZK_DISABLE_TRACKER=true
fi

if [ -f "/usr/local/bin/azk" ]; then
  alias bazk='/usr/local/bin/azk'
  alias bdocker='/usr/local/bin/adocker'
fi

# powerline
if [[ -r ~/.local/lib/python2.7/site-packages/ ]]; then
  export PYTHON_PACKAGE="$HOME/.local/lib/python2.7/site-packages/"
elif [[ -r /usr/local/lib/python2.7/site-packages/ ]]; then
  export PYTHON_PACKAGE="/usr/local/lib/python2.7/site-packages/"
elif [[ -r $HOME/Library/Python/2.7/lib/python/site-packages/ ]]; then
  export PYTHON_PACKAGE="$HOME/Library/Python/2.7/lib/python/site-packages"
elif [[ -r /Library/Python/2.7/site-packages/ ]]; then
  export PYTHON_PACKAGE="/Library/Python/2.7/site-packages"
fi

# if [[ -e "$PYTHON_PACKAGE/powerline/bindings/zsh/powerline.zsh" ]]; then
#   source $PYTHON_PACKAGE/powerline/bindings/zsh/powerline.zsh
# fi

