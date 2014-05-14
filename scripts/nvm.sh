if [ -d $HOME/.nvm ]; then
  [[ -s $HOME/.nvm/nvm.sh         ]] && . $HOME/.nvm/nvm.sh # Load nvm into a shell session *as a function*
  [[ -r $NVM_DIR/bash_completion  ]] && . $NVM_DIR/bash_completion
fi
