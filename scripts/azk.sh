# azk
export AZK_HOME="$HOME/.azk"
if [ -d "$AZK_HOME" ]; then
  export PATH=$AZK_HOME/bin:$PATH
fi
