#!/bin/sh

# Make Defaults Links
set -e
BASE_PATH=$HOME/Sync/gullitmiranda@gmail.com/dotfiles
ln -sf ${BASE_PATH}/Documents $HOME/
ln -sf ${BASE_PATH}/Pictures  $HOME/

# Works
ln -sf ${BASE_PATH}/Works         $HOME/
ln -sf ${BASE_PATH}/Works/azuki   $HOME/
ln -sf ${BASE_PATH}/Works/request $HOME/

# ########
# DOTFILES
# ########

## atom
base=${BASE_PATH}/.atom
to=${HOME}/.atom/
mkdir -p ${to}
ln -sf ${base}/* ${to}/

## terminal and zsh
ln -sf ${BASE_PATH}/tmux.conf         $HOME/.tmux.conf
ln -sf ${BASE_PATH}/.zdirs            $HOME/.zdirs
ln -sf ${BASE_PATH}/.oh-my-zsh        $HOME/.oh-my-zsh
ln -sf ${BASE_PATH}/.zsh-update       $HOME/.zsh-update
ln -sf ${BASE_PATH}/.zshenv           $HOME/.zshenv
ln -sf ${BASE_PATH}/.zshrc            $HOME/.zshrc

## git
ln -sf ${BASE_PATH}/.gitconfig        $HOME/.gitconfig
ln -sf ${BASE_PATH}/.gitignore_global $HOME/.gitignore
