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
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/dotfiles/bin:$PATH"

# add the mise shim directory to PATH. https://mise.jdx.dev/ide-integration.html
eval "$(mise activate zsh --shims)"

# export PATH="$HOME/.profile:$PATH"
