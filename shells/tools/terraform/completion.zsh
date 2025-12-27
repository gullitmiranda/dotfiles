# Terraform/OpenTofu completion
# This replaces the lines added by terraform/tofu -install-autocomplete
# Reference: https://developer.hashicorp.com/terraform/cli/commands#shell-tab-completion

# Initialize bashcompinit for bash-style completions (terraform uses this)
autoload -U +X bashcompinit && bashcompinit

# Terraform native completion (bash-style)
if command -v terraform >/dev/null 2>&1; then
	complete -o nospace -C "$(command -v terraform)" terraform
fi

# OpenTofu native completion (bash-style)
if command -v tofu >/dev/null 2>&1; then
	complete -o nospace -C "$(command -v tofu)" tofu
fi

# Custom zsh completion for subcommand aliases
# These simulate "terraform <subcmd> ..." completion by prepending the subcommand
_terraform_subcmd_complete() {
	local cmd="$1"
	local subcmd="$2"

	# Get the current command line after the alias
	local args="${words[2,-1]}"

	# Build fake command line: "terraform plan <args>"
	local fake_line="${cmd} ${subcmd} ${args}"

	# Use terraform's completion by setting COMP_LINE
	local completions
	completions=$(COMP_LINE="$fake_line" COMP_POINT=${#fake_line} "$cmd" 2>/dev/null)

	# Add completions to zsh
	local IFS=$'\n'
	compadd -Q -S '' -- ${(f)completions}
}

# Terraform subcommand completion functions
_tfplan() { _terraform_subcmd_complete terraform plan; }
_tfapply() { _terraform_subcmd_complete terraform apply; }
_tfinit() { _terraform_subcmd_complete terraform init; }
_tfdestroy() { _terraform_subcmd_complete terraform destroy; }

# OpenTofu subcommand completion functions
_tfuplan() { _terraform_subcmd_complete tofu plan; }
_tfuapply() { _terraform_subcmd_complete tofu apply; }
_tfuinit() { _terraform_subcmd_complete tofu init; }
_tfudestroy() { _terraform_subcmd_complete tofu destroy; }

# Register zsh completions
if command -v compdef >/dev/null 2>&1; then
	# Pass-through aliases get full completion
	if command -v tofu >/dev/null 2>&1; then
		compdef '_dispatch tofu tofu' tfu
	fi
	if command -v terraform >/dev/null 2>&1; then
		compdef '_dispatch terraform terraform' tf
	fi

	# Subcommand aliases get subcommand-specific completion
	if command -v terraform >/dev/null 2>&1; then
		compdef _tfplan tfplan
		compdef _tfapply tfapply
		compdef _tfinit tfinit
		compdef _tfdestroy tfdestroy
	fi
	if command -v tofu >/dev/null 2>&1; then
		compdef _tfuplan tfuplan
		compdef _tfuapply tfuapply
		compdef _tfuinit tfuinit
		compdef _tfudestroy tfudestroy
	fi
fi
