# Terragrunt completion
# Uses terragrunt's built-in bash completion via bashcompinit

autoload -U +X bashcompinit && bashcompinit

if command -v terragrunt >/dev/null 2>&1; then
	complete -o nospace -C "$(command -v terragrunt)" terragrunt
fi

if command -v compdef >/dev/null 2>&1 && command -v terragrunt >/dev/null 2>&1; then
	compdef '_dispatch terragrunt terragrunt' tg
fi
