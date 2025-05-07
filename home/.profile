# NOTE: Text copied from an ubuntu machine
#
# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# # if running bash
# if [ -n "$BASH_VERSION" ]; then
#     # include .bashrc if it exists
#     if [ -f "$HOME/.bashrc" ]; then
#      	. "$HOME/.bashrc"
#     fi
# fi

# # set PATH so it includes user's private bin if it exists
# if [ -d "$HOME/bin" ] ; then
#     PATH="$HOME/bin:$PATH"
# fi

# # set PATH so it includes user's private bin if it exists
# if [ -d "$HOME/.local/bin" ] ; then
#     PATH="$HOME/.local/bin:$PATH"
# fi

### ----------------


SHELL_DEBUG_FILE=$HOME/.shell.debug
now=$(date +%Y-%m-%dT%H:%M:%S%z)
echo -e "\n\n" >>$SHELL_DEBUG_FILE
echo ".profile $now" >>$SHELL_DEBUG_FILE

echo "env:" >>$SHELL_DEBUG_FILE
env >>$SHELL_DEBUG_FILE
echo -e "----\n" >>$SHELL_DEBUG_FILE

# echo "_=$_" >>$SHELL_DEBUG_FILE
# echo "PATH=$PATH" >>$SHELL_DEBUG_FILE
# echo "TERM_PROGRAM=$TERM_PROGRAM" >>$SHELL_DEBUG_FILE
# echo "mise env:" >>$SHELL_DEBUG_FILE
# echo $(mise env) >>$SHELL_DEBUG_FILE

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

# disable homebrew auto update
export HOMEBREW_NO_AUTO_UPDATE=1

export PATH="/opt/homebrew/sbin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/dotfiles/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# # add the mise shim directory to PATH. https://mise.jdx.dev/dev-tools/shims.html#zshrc-bashrc-files
# # the activate with --shims should go first because it's will be replace by `mise hook-env -s zsh` on interative shells
# eval "$(mise activate zsh --shims)"
# alias asdf="mise"

export PATH_PROFILE="$PATH_PROFILE:$HOME/.profile"

# if the file ~/.env.sh exists, source it
if test -f ~/.env.sh
    source ~/.env.sh
end

# https://direnv.net/
# NOTE: when installed using brew, already loaded, but it will not be loaded in other apps
if type -q direnv
    direnv hook bash | source
end

# # Ruby
# export GEM_HOME="$HOME/.gem"
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
