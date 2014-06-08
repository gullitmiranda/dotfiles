export PATH="$PATH:./bin:$HOME/.dotfiles/bin:$HOME/bin:$HOME/local/bin:$HOME/local/sbin:/bin:/sbin:/usr/bin:/usr/local/bin:/usr/local/sbin:/usr/sbin:/usr/X11/bin"
# export INSTALL_DIR="$HOME/local"
export EVENT_NOKQUEUE=1
export MANPATH=/usr/local/git/man:$MANPATH

rvm_available=$(command -v rvm)
rbenv_available=$(command -v rbenv)

if [[ "$(uname)" != "Darwin" ]]; then
  export EDITOR=vim
else
  export EDITOR="$HOME/bin/subl -w"
fi

export SVN_EDITOR="/usr/bin/subl -w"
export HISTCONTROL=ignoreboth
export HISTFILESIZE=1000000
export HISTIGNORE="&"
export HISTSIZE=${HISTFILESIZE}
export GREP_OPTIONS="--color=auto"
export GREP_COLOR="4;33"
export CDPATH=.:~:~/dev:/wwww:~/www:~/dev/wwww
export CDHISTORY="/tmp/cd-${USER}"

export RUBYLIB='.'
export RUBYOPT=''
export RUBY_VERSION="$(ruby -e 'print RUBY_VERSION')"


if [[ !"$rvm_available" && !"$rbenv_available" ]]; then
  export GEM_HOME="$HOME/local/ruby/gems/$RUBY_VERSION"
fi

export PATH="$PATH:$GEM_HOME/bin"

export LESS_TERMCAP_mb=$'\E[04;33m'
export LESS_TERMCAP_md=$'\E[04;33m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[00;32m'

# Java
export JAVA_HOME="/usr/lib/jvm/java-7-openjdk-amd64/"
# export JAVA_HOME="/Library/Java/Home"
