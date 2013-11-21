#!/bin/sh

if [ ! -d "$HOME/.dotfiles" ]; then
  echo "Installing YADR for the first time"
  git clone https://github.com/gullitmiranda/dotfiles "$HOME/.dotfiles"
  cd "$HOME/.dotfiles"
  [ "$1" == "ask" ] && export ASK="true"
  echo "
if [ -f ~/.dotfiles/.bash_profile ]; then
. ~/.dotfiles/.bash_profile
fi " >> ~/.bashrc
  rake install
else
  echo "You DotFiles is already installed"
fi
