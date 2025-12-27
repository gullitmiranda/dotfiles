# Expand aliases before execution (similar to Fish's behavior)
function expand_alias() {
  if [[ $ZSH_VERSION ]]; then
    # Get the full command line from preexec
    local cmd_line="$1"
    
    # Extract the first word (command) from the command line
    local cmd="${cmd_line%% *}"
    
    # Skip if no command or if it's a builtin/function
    if [[ -z "$cmd" ]] || [[ "$(type -w "$cmd" 2>/dev/null)" =~ "builtin|function" ]]; then
      return
    fi
    
    # Check if it's an alias
    if alias "$cmd" &>/dev/null; then
      # Get the expanded alias using zsh's built-in alias expansion
      local expanded=$(alias "$cmd" 2>/dev/null)
      
      if [[ -n "$expanded" ]]; then
        # Extract the alias value more reliably
        local alias_value=$(echo "$expanded" | sed -E "s/^alias $cmd=['\"](.*)['\"]$/\1/")
        
        if [[ -n "$alias_value" ]]; then
          # Print the expanded command in cyan color
          echo -e "\033[0;36m# alias $alias_value\033[0m"
        fi
      fi
    fi
  fi
}

# Add the preexec hook to show alias expansion
autoload -U add-zsh-hook
add-zsh-hook preexec expand_alias
