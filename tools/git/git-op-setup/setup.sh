#!/usr/bin/env bash

# Configure git using $DOTFILES_DIR/local/gitconfig.json, which is generated from config.yaml git
# variables

set -euo pipefail

### Configurations

dotfiles_local_dir="${DOTFILES_DIR:-$HOME/.dotfiles}/local"
gitconfig_json_path="$dotfiles_local_dir/gitconfig.json"
local_git_file="$HOME/.gitconfig.local"

OP_SSH_AGENT_SOCKET_PATH="${OP_SSH_AGENT_SOCKET_PATH:-$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock}"
OP_SSH_AGENT_CONFIG_PATH="${OP_SSH_AGENT_CONFIG_PATH:-$HOME/.config/1Password/ssh/agent.toml}"
OP_LINK_DIR="${OP_LINK_DIR:-$HOME/.1password}"

debug_mode="${DEBUG:-false}"
force_mode=false

for arg in "$@"; do
	case "$arg" in
	--force) force_mode=true ;;
	esac
done

### Helpers

log() {
	local level="$1"
	local msg="$2"
	[[ $level == "debug" && $debug_mode != "true" ]] && return
	echo "$level: $msg"
}

expand_tilde() {
	echo "${1/#\~/$HOME}"
}

create_link() {
	local src
	local dst
	src="$(expand_tilde "$1")"
	dst="$(expand_tilde "$2")"

	log debug "     > ln -s $src $dst"

	if [[ -e $dst ]]; then
		if [[ $force_mode == "true" ]]; then
			log warn "Overwriting existing link: $dst"
			rm "$dst"
		else
			log warn "Link already exists: $dst"
			return
		fi
	fi
	ln -s "$src" "$dst"
}

check_cmd() {
	local cmd="$1"
	local msg="$2"
	if ! command -v "$cmd" &>/dev/null; then
		echo "Error: $msg"
		exit 1
	fi
}

### Git config helpers

git_config() {
	local config_file
	config_file="$(expand_tilde "$1")"
	local key="$2"
	local value="$3"
	log debug "     > git config --file $config_file '$key' '$value'"
	git config --file "$config_file" "$key" "$value"
}

git_config_from_json() {
	local config_file="$1"
	local config_data="$2"
	log info "Setting git config to $config_file"
	while IFS= read -r key; do
		local value
		value="$(echo "$config_data" | jq -r --arg k "$key" '.[$k]')"
		git_config "$config_file" "$key" "$value"
	done < <(echo "$config_data" | jq -r 'keys[]')
}

### Setup functions

setup_git_local_main_configs() {
	local config_data
	config_data="$(echo "$1" | jq -c '.config')"
	git_config_from_json "$local_git_file" "$config_data"
	mkdir -p "$dotfiles_local_dir"
	create_link "$local_git_file" "$dotfiles_local_dir/.gitconfig.local"
}

configure_accounts() {
	local data="$1"
	local count
	count="$(echo "$data" | jq '.accounts | length')"

	for i in $(seq 0 $((count - 1))); do
		local account
		account="$(echo "$data" | jq -c ".accounts[$i]")"
		local account_name
		account_name="$(echo "$account" | jq -r '.name')"
		log info "Configuring account: $account_name"

		if ! configure_git_account "$account"; then
			log error "Failed to configure Git account: $account_name"
		else
			log info "Git account configured: $account_name"
		fi
	done

	log info "All accounts configured"
	log info "      You can see a list of all the gitconfig files in $dotfiles_local_dir"
}

configure_git_account() {
	local account="$1"
	local account_name
	account_name="$(echo "$account" | jq -r '.name')"
	local account_git_file
	account_git_file="$(echo "$account" | jq -r '.file')"
	local real_account_git_file
	real_account_git_file="$(expand_tilde "$account_git_file")"
	local account_config_data
	account_config_data="$(echo "$account" | jq -c '.config')"

	log debug "     - account_git_file=$account_git_file"
	log debug "     - account_config_data=$account_config_data"

	# Ensure parent directory exists
	mkdir -p "$(dirname "$real_account_git_file")"

	git_config_from_json "$real_account_git_file" "$account_config_data"

	# Add one includeIf per gitdir
	local gitdir_count
	gitdir_count="$(echo "$account" | jq '.gitdirs | length')"
	for i in $(seq 0 $((gitdir_count - 1))); do
		local gitdir
		gitdir="$(echo "$account" | jq -r ".gitdirs[$i]")"
		git_config "$local_git_file" "includeIf.gitdir:$gitdir.path" "$account_git_file"
	done

	create_link "$real_account_git_file" "$dotfiles_local_dir/.gitconfig.$account_name"

	# Optional: 1Password SSH keys + core.sshCommand setup
	local has_op
	has_op="$(echo "$account" | jq 'has("op")')"
	if [[ ${has_op} == "true" ]]; then
		# Determine private key path to set core.sshCommand
		local ssh_private_key=""
		local has_keys
		has_keys="$(echo "$account" | jq '.op | has("keys")')"
		if [[ ${has_keys} == "true" ]]; then
			ssh_private_key="$(echo "${account}" | jq -r '.op.keys[] | select(.field == "private key") | .output')"
		else
			local field
			field="$(echo "${account}" | jq -r '.op.field // empty')"
			[[ ${field} == "private key" ]] && ssh_private_key="$(echo "${account}" | jq -r '.op.output')"
		fi

		if [[ -n ${ssh_private_key} ]]; then
			local expanded_key
			expanded_key="$(expand_tilde "${ssh_private_key}")"
			log info "Setting core.sshCommand for ${account_name} (key: ${expanded_key})"
			git_config "${real_account_git_file}" "core.sshCommand" "ssh -i ${expanded_key} -F /dev/null"
		fi

		# Download keys from 1Password
		if ! command -v op &>/dev/null; then
			log warn "op (1Password CLI) not found — skipping SSH key download for $account_name"
		else
			download_1password_keys "$account"
		fi
	fi
}

download_1password_keys() {
	local account="$1"
	local op_account op_item op_vault
	op_account="$(echo "$account" | jq -r '.op.account')"
	op_vault="$(echo "$account" | jq -r '.op.vault')"
	op_item="$(echo "$account" | jq -r '.op.item')"

	# Support both old format (single field+output) and new format (keys array)
	local has_keys
	has_keys="$(echo "$account" | jq '.op | has("keys")')"

	if [[ $has_keys == "true" ]]; then
		local key_count
		key_count="$(echo "$account" | jq '.op.keys | length')"
		for i in $(seq 0 $((key_count - 1))); do
			local field output_file secret_ref
			field="$(echo "$account" | jq -r ".op.keys[$i].field")"
			output_file="$(expand_tilde "$(echo "$account" | jq -r ".op.keys[$i].output")")"
			secret_ref="op://$op_vault/$op_item/$field"
			download_1password_secret "$op_account" "$secret_ref" "$output_file"
		done
	else
		# Legacy single field+output format
		local field output_file secret_ref
		field="$(echo "$account" | jq -r '.op.field')"
		output_file="$(expand_tilde "$(echo "$account" | jq -r '.op.output')")"
		secret_ref="op://$op_vault/$op_item/$field"
		download_1password_secret "$op_account" "$secret_ref" "$output_file"
	fi
}

download_1password_secret() {
	local op_account="$1"
	local secret_ref="$2"
	local output_file="$3"

	log info "Downloading \"$secret_ref\" to \"$output_file\" from $op_account"

	if [[ -f $output_file && $force_mode != "true" ]]; then
		log warn "File already exists: $output_file"
		return 0
	fi

	mkdir -p "$(dirname "$output_file")"

	local force_flag=""
	[[ $force_mode == "true" ]] && force_flag="--force"

	# Append ssh-format=openssh for private key fields (op CLI defaults to PKCS#8)
	if [[ $secret_ref == *"private key"* ]]; then
		secret_ref="${secret_ref}?ssh-format=openssh"
	fi

	if ! op read $force_flag --account "$op_account" "$secret_ref" --out-file "$output_file"; then
		log error "Failed to download from 1Password ($op_account): \"$secret_ref\""
		return 1
	fi

	chmod 600 "$output_file"
}

link_1password_ssh_agent_files() {
	mkdir -p "$OP_LINK_DIR"
	create_link "$OP_SSH_AGENT_SOCKET_PATH" "$OP_LINK_DIR/agent.sock"
	create_link "$OP_SSH_AGENT_CONFIG_PATH" "$OP_LINK_DIR/agent.toml"
}

check_1password_ssh_agent() {
	if [[ -n ${SSH_AUTH_SOCK-} ]] && echo "$SSH_AUTH_SOCK" | grep -q '1password'; then
		log info "SSH_AUTH_SOCK is set for 1Password."
		return
	fi

	if [[ -f "$HOME/.ssh/config" ]] && grep -q 'IdentityAgent.*1password' "$HOME/.ssh/config"; then
		log info "IdentityAgent is configured for 1Password in $HOME/.ssh/config."
		return
	fi

	log warn "1Password SSH agent not detected in SSH_AUTH_SOCK or ~/.ssh/config. Skipping agent check."
}

### Allowed signers

generate_allowed_signers() {
	local data="$1"
	local allowed_signers_file="$HOME/.ssh/allowed_signers"
	local count
	count="$(echo "$data" | jq '.accounts | length')"
	local entries=()

	for i in $(seq 0 $((count - 1))); do
		local account
		account="$(echo "$data" | jq -c ".accounts[$i]")"
		local email pub_key_file
		email="$(echo "$account" | jq -r '.config["user.email"]')"
		pub_key_file="$(expand_tilde "$(echo "$account" | jq -r '.config["user.signingkey"]')")"

		# Try .pub file first, fall back to signingkey path itself
		if [[ -f "${pub_key_file}.pub" ]]; then
			pub_key_file="${pub_key_file}.pub"
		elif [[ ! -f $pub_key_file ]]; then
			log warn "No public key found for $email, skipping allowed_signers entry"
			continue
		fi

		local pub_key
		pub_key="$(cat "$pub_key_file")"
		local entry="${email} ${pub_key}"

		# Avoid duplicates (oss and personal share the same key)
		local is_dup=false
		for existing in "${entries[@]+"${entries[@]}"}"; do
			[[ $existing == "$entry" ]] && is_dup=true && break
		done
		[[ $is_dup == true ]] && continue

		entries+=("$entry")
	done

	if [[ ${#entries[@]} -eq 0 ]]; then
		warn "No signing keys found, skipping allowed_signers generation"
		return 0
	fi

	printf '%s\n' "${entries[@]}" >"$allowed_signers_file"
	chmod 644 "$allowed_signers_file"
	log info "Generated $allowed_signers_file with ${#entries[@]} entries"
}

### Prerequisites

check_cmd jq "jq is not installed. You can install it using 'brew install jq'"
check_cmd git "git is not installed. Please install it using 'brew install git'"

### Execute

log info "Reading $gitconfig_json_path..."
if [[ ! -f $gitconfig_json_path ]]; then
	echo "Error: $gitconfig_json_path does not exist. Please ensure the file is created as per the installation instructions."
	exit 1
fi
gitconfig_data="$(jq -c '.' "$gitconfig_json_path")"
log debug "     - gitconfig_data=$gitconfig_data"

log info "Setting up git local main configs..."
setup_git_local_main_configs "$gitconfig_data"

log info "Configuring accounts..."
configure_accounts "$gitconfig_data"

log info "Generating allowed_signers file..."
generate_allowed_signers "$gitconfig_data"

# Optional: 1Password SSH agent linking
# Disabled by default — Git auth uses HTTPS via `gh`, signing uses local pub keys.
# To opt-in, set git.op_link_agent: true in config.yaml
op_link_agent="$(echo "$gitconfig_data" | jq -r '.op_link_agent // false')"
if [[ $op_link_agent == "true" ]]; then
	log info "Linking 1Password SSH agent files..."
	link_1password_ssh_agent_files

	log info "Checking 1Password SSH agent..."
	check_1password_ssh_agent
else
	log info "Skipping 1Password agent linking (OP_LINK_AGENT not set)"
fi

log info "Done."
