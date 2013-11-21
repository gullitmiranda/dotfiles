#!/bin/sh

if [ ! -d "$HOME/.dotfiles" ]; then
    echo "Installing YADR for the first time"
    git clone https://github.com/gullitmiranda/dotfiles "$HOME/.dotfiles"
    cd "$HOME/.dotfiles"
    [ "$1" == "ask" ] && export ASK="true"
    rake install
else
    echo "You DotFiles is already installed"
fi
