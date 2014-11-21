# azk
export AZK_HOME="$HOME/.azk"
if [ -d "$AZK_HOME" ]; then
  export PATH=$AZK_HOME/bin:$PATH
  # export AZK_DNS_PORT=5353
fi
