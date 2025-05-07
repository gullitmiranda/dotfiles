SHELL_DEBUG_FILE=$HOME/.shell.debug
now=$(date +%Y-%m-%dT%H:%M:%S%z)

echo -e "\n\n" >>$SHELL_DEBUG_FILE
echo ".zprofile $now" >>$SHELL_DEBUG_FILE

echo "env:" >>$SHELL_DEBUG_FILE
env >>$SHELL_DEBUG_FILE
echo -e "----\n" >>$SHELL_DEBUG_FILE

[ -f ~/.profile ] && source ~/.profile

export PATH="$PATH:$HOME/.zprofile"
