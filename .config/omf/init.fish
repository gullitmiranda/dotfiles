# set -U EDITOR vim
set -gx CDPATH . $HOME/Works $HOME/Works/yube $HOME/Works/azuki-sh $HOME/Works/azuki $HOME/Works/azuki-mafia $HOME/Works/request $HOME/odrive/pessoal $HOME
set -gx PATH $HOME/dotfiles/bin /opt $PATH
set -gx ANDROID_HOME $HOME/Library/Android/sdk

source ~/dotfiles/.iterm2_shell_integration.fish
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
# set -g theme_newline_chart "↪"
# set -g theme_newline_chart "$right_arrow_glyph"

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
      set -l default_repo (git rev-parse --show-cdup)
      set -q $repo; and set -l repo "$default_repo"
      open -a SourceTree "$repo"
    end
    alias st='sourcetree'

    alias ccat='pygmentize'

    alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
    alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
end

function agrep -a str -d "grep in aliases"
  alias | grep "$str"
end

function hgrep -a str -d "grep in history"
  builtin history | grep -v grep | grep "$str"
end

function egrep -a str -d "grep in env variables"
  env | grep "$str"
end

function pgrep -a str -d "grep in all running process"
  command ps aux | grep -v grep | grep "$str"
end

## TODOs
alias atodo='code ~/Works/azuki/TODO'
alias btodo='code ~/Works/brainn-co/TODO'
alias ytodo='code ~/Works/yube/TODO'
alias ptodo='code ~/Documents/Personal.todo'

# https://github.com/fish-shell/fish-shell/issues/1156#issuecomment-371493891
function fishcognito
    env fish_history='' fish
end

#----
# DevOps

# gcloud
if test (which gcloud)
  set gcloud_bin_dir (dirname (readlink (which gcloud)))
  set -gx PATH $PATH $gcloud_bin_dir
end

# helm configs
if test (which helm)
  and test -z "$HELM_HOME"
  set -gx HELM_HOME (helm home)
end

#----
# Dev

# Elixir/Erlang config
set -gx ERL_AFLAGS "-kernel shell_history enabled"

## GoLang
set -gx GOPATH $HOME/Works/git/go

# ## NodeJS
# fix conflic which asdf-nodejs which dependecy shim
set -gx PATH /usr/local/bin /usr/bin /bin /usr/sbin /sbin $PATH

set -gx PATH $PATH (yarn global bin)
set -gx PATH $PATH ./node_modules/.bin

# Rust
set -gx PATH $PATH $HOME/.cargo/bin
