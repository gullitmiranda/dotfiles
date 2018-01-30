# set -U EDITOR vim
set -gx CDPATH $HOME/Works $HOME/Works/brainn-co $HOME/Works/azuki-sh $HOME/Works/azuki $HOME/Works/request $HOME/odrive/pessoal $HOME
set -gx PATH $HOME/dotfiles/bin $PATH
set -gx ANDROID_HOME $HOME/Library/Android/sdk

source ~/.iterm2_shell_integration.fish
source ~/.env.sh

#----
# Theme configs

# https://github.com/oh-my-fish/oh-my-fish/blob/master/docs/Themes.md#configuration
set -g theme_title_display_path yes
set -g theme_title_use_abbreviated_path no
set -g theme_date_format "+%a %H:%M:%S"
set -g theme_display_docker_machine no
set -g theme_newline_cursor yes

# with custom functions
set -g theme_newline_chart "↪"

#----
# Aliases

source (dirname (status filename))/alias/git.fish

abbr -a datestamp date +%Y%m%d-%H%M%S
abbr -a dateiso date +%Y-%m-%dT%H:%M:%S%z

if test -f "/usr/local/bin/exa"
  alias la='exa -abghHliS'
end

switch (uname)
  case Darwin
    function sourcetree -a repo
      # when repo is not defined use "."
      set -q $repo; and set -l repo "."
      open -a SourceTree "$repo"
    end
    alias st='sourcetree'

    alias ccat='pygmentize'

    alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
    alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
end

alias hgrep='history | grep'
alias pgrep='ps aux | grep -v grep | grep'
alias egrep='env | grep'
alias agrep='alias | grep'

## TODOs
alias atodo='code ~/Works/azuki/TODO'
alias ytodo='code ~/Works/yube/TODO'
alias ptodo='code ~/Documents/Personal.todo'

#----
# Dev

## NodeJS
set -gx PATH (yarn global bin) $PATH
set -gx PATH ./node_modules/.bin $PATH

## GoLang
set -gx GOPATH $HOME/Works/git/go

# DevOps configs
if test (which helm)
  set -gx HELM_HOME (helm home)
end
