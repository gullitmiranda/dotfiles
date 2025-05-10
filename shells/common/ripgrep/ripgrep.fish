# ripgrep configuration for fish
# -----------------------

# Make sure ripgrep is installed
if command -v rg >/dev/null 2>&1
  # Define helper aliases for common search patterns
  alias rgh 'rg --hidden'
  alias rgf 'rg --files | rg'
  alias rgc 'rg --count'
  
  # Integration with fzf if available
  if command -v fzf >/dev/null 2>&1
    # Interactive ripgrep
    function rgfzf
      set RG_PREFIX "rg --column --line-number --no-heading --color=always --smart-case "
      set INITIAL_QUERY $argv
      echo | fzf --ansi --disabled --query "$INITIAL_QUERY" \
          --bind "start:reload:$RG_PREFIX {q}" \
          --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
          --delimiter : \
          --preview 'bat --color=always {1} --highlight-line {2}' \
          --preview-window 'up,60%,border-bottom,+{2}+3/3,~3'
    end
  end
end