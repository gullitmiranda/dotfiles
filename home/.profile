## This file will be loaded by bash (.bashrc) and zsh (.zshrc)
#########

# Setup asdf - https://asdf-vm.com/guide/getting-started.html#_1-install-dependencies
#################################
# brew install autoconf automake coreutils libtool libyaml openssl@1.1 readline unixodbc

# Setup erlang - https://github.com/asdf-vm/asdf-erlang#osx
#################################
# brew install autoconf openssl@1.1 wxwidgets libxslt fop

# https://dev.to/onpointvn/installing-erlang-elixir-on-m1-macs-1b8g
# https://cpufun.substack.com/p/setting-up-the-apple-m1-for-native

# if [ "$(uname -s)" == "Darwin" ]; then
#   # Switch to an arm64e shell by default
#   # if [ $(machine) != arm64e ]; then
#   #   echo 'Execing arm64 shell'
#   #   exec arch -arm64 shell
#   # fi
#   # if ["$(sysctl -n machdep.cpu.brand_string)" == "Apple M1" ]; then
#   #   export HOMEBREW_PREFIX="/opt/homebrew"
#   #   export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
#   #   export HOMEBREW_REPOSITORY="/opt/homebrew"
#   #   export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}"
#   #   export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
#   #   export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"
#   # else
#   #   export HOMEBREW_PREFIX="/usr/local"
#   #   export HOMEBREW_CELLAR="/usr/local/Cellar"
#   #   export HOMEBREW_REPOSITORY="/usr/local"
#   #   export PATH="/usr/local/bin:/usr/local/sbin${PATH+:$PATH}"
#   #   export MANPATH="/usr/local/share/man${MANPATH+:$MANPATH}:"
#   #   export INFOPATH="/usr/local/share/info:${INFOPATH:-}"
#   # fi

#   if [ "$(uname -p)" = "i386" ]; then
#     echo "Running in intel arch (Rosetta)"
#     eval "$(/usr/local/bin/brew shellenv)"
#     # alias brew='/usr/local/homebrew/bin/brew'
#   else
#     echo "Running in ARM arch"
#     eval "$(/opt/homebrew/bin/brew shellenv)"
#     # alias brew='/opt/homebrew/bin/brew'
#   fi

#   alias arm='arch -arm64e $SHELL -l'
#   alias intel='arch -x86_64 $SHELL -l'

#   alias abrew='arch -arm64e /opt/homebrew/bin/brew'
#   alias ibrew='arch -x86_64 /usr/local/bin/brew'
# fi

# 
export PATH="$PATH:$HOME/.local/bin"
export PATH="/opt/homebrew/bin:$PATH"
