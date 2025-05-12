#!/usr/bin/env fish

# Configure git using $DOTFILES_DIR/local/gitconfig.json, which is generated from config.yaml git
# variables

if not command -q op
    echo "Error: op (1password cli) is not installed. Please install it by following the instructions at https://developer.1password.com/docs/cli/get-started"
    exit 1
end

if not command -q jq
    echo "Error: jq is not installed. You can install it using 'brew install jq'"
    exit 1
end

if not command -q git
    echo "Error: git is not installed. Please install it using 'brew install git'"
    exit 1
end

### Configurations

set dotfiles_local_dir "$DOTFILES_DIR/local"
set gitconfig_json_path "$dotfiles_local_dir/gitconfig.json"

set local_git_file "$HOME/.gitconfig.local"

set -q OP_SSH_AGENT_SOCKET_PATH; or set OP_SSH_AGENT_SOCKET_PATH "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
set -q OP_SSH_AGENT_CONFIG_PATH; or set OP_SSH_AGENT_CONFIG_PATH "$HOME/.config/1Password/ssh/agent.toml"
set -q OP_LINK_DIR; or set OP_LINK_DIR "$HOME/.1password"

# Set debug_mode based on the DEBUG environment variable
set debug_mode (set -q DEBUG; and echo true; or echo false)

# Parse command line arguments
set force_mode false

for arg in $argv
    switch $arg
        case --force
            set force_mode true
        case '*'
            # Handle other arguments if necessary
    end
end

# Use force_mode in relevant parts of the script
if test "$force_mode" = true
    log info "Force mode is enabled"
    # Implement force logic here, e.g., skip checks or overwrite files
end

if test "$debug_mode" = true
    echo "debug: Configs:"
    echo "debug: debug_mode=$debug_mode"
    echo "debug: force_mode=$force_mode"
    echo "debug: dotfiles_local_dir=$dotfiles_local_dir"
    echo "debug: gitconfig_json_path=$gitconfig_json_path"
    echo "debug: local_git_file=$local_git_file"
    echo "debug: OP_SSH_AGENT_SOCKET_PATH=$OP_SSH_AGENT_SOCKET_PATH"
    echo "debug: OP_SSH_AGENT_CONFIG_PATH=$OP_SSH_AGENT_CONFIG_PATH"
    echo "debug: OP_LINK_DIR=$OP_LINK_DIR"
end

### Functions

#### Helper Functions

# Define log levels and their corresponding colors in a list
set log_levels debug info warn error
set log_colors normal blue yellow red

# Function to get the color for a given log level
function get_log_color
    set -l level $argv[1]
    if set -l index (contains -i -- $level $log_levels) # `set` won't modify $status, so this succeeds if `contains` succeeds
        echo $log_colors[$index]
        return
    end
end

# Log function
function log
    set -l level $argv[1]
    set -l msg $argv[2]

    # Skip debug messages if debug mode is OFF
    if test "$level" = debug -a "$debug_mode" = false
        return
    end

    set_color (get_log_color $level)
    echo -e "$level: $msg"
end

# Function to create symbolic links with optional force mode
function create_link
    set -l src (expand_tilde $argv[1])
    set -l dst (expand_tilde $argv[2])

    log debug "     > ln -s $src $dst"

    if test -e $dst
        if test "$force_mode" = true
            log warn "Overwriting existing link: $dst"
            rm $dst
        else
            log warn "Link already exists: $dst"
            return
        end
    end
    ln -s $src $dst
end

# Function to expand tilde to full path
function expand_tilde
    set -l path $argv[1]
    string replace "~" $HOME $path
end

# Function to read and parse gitconfig.json
function read_git_config_json_data
    set -l config_file $argv[1]
    if not test -f "$config_file"
        log error "$config_file does not exist. Please ensure the file is created as per the installation instructions." >&2
        exit 1
    end

    # Read and parse gitconfig.json
    log debug "     Found $config_file, reading data..." >&2
    cat $config_file | jq -c '.'
end

#### Git Config Functions

function git_config_from_json
    set -l config_file $argv[1]
    set -l config_data $argv[2]
    set -l git_config_cmd "git config --file $config_file"

    log info "Setting git config to $config_file"
    log debug "     - config_data=$config_data"

    for key in (echo $config_data | jq -r 'keys[]')
        set value (echo $config_data | jq -r --arg k "$key" '.[$k]')
        git_config $config_file $key $value
    end
end

function git_config
    set -l config_file (expand_tilde $argv[1]) # Expand ~ to the full path
    set -l key $argv[2]
    set -l value $argv[3]

    log debug "     > git config --file $config_file '$key' $value"
    git config --file $config_file "$key" "$value"
end

# Setup the gitconfig.local file

function setup_git_local_main_configs
    set -l config_data (echo $argv | jq -c '.config')
    git_config_from_json $local_git_file $config_data
    create_link $local_git_file "$dotfiles_local_dir/.gitconfig.local"
end

# Setup accounts

function configure_accounts
    for account in (echo $argv | jq -c '.accounts[]')
        set account_name (echo $account | jq -r '.name')
        log info "Configuring account: $account_name"

        if not configure_git_account $account
            log error "‼️  Failed to configure Git account: $account_name"
        else
            log info "✅ Git account configured: $account_name"
        end
    end
    log info "✅ All accounts configured"
    log info "      You can see a list of all the gitconfig files in $dotfiles_local_dir"
end

function configure_git_account
    # Configure each Git account using gitconfig.json
    set account_name (echo $argv | jq -r '.name')
    set account_git_file (echo $argv | jq -r '.file')
    set gitdir (echo $argv | jq -r '.gitdir')
    set ssh_key_path (expand_tilde (echo $argv | jq -r '.op.output'))
    set account_config_data (echo $argv | jq -c '.config')

    set real_account_git_file (expand_tilde $account_git_file)

    log debug "     - account_git_file=$account_git_file"
    log debug "     - ssh_key_path=$ssh_key_path"
    log debug "     - account_config_data=$account_config_data"

    # Set custom git config for each account
    git_config_from_json $real_account_git_file $account_config_data

    # Set the core.sshCommand for each account
    git_config $real_account_git_file core.sshCommand "ssh -i $ssh_key_path"

    # add the gitdir to the gitconfig.local file
    git_config $local_git_file includeIf."gitdir:$gitdir".path $account_git_file

    create_link $real_account_git_file "$dotfiles_local_dir/.gitconfig.$account_name"

    # Download the 1Password keys for this account
    download_1password_pub_ssh_key $argv
end

# Download public keys from 1Password using account information
function download_1password_pub_ssh_key
    set account (echo $argv)
    set op_account (echo $account | jq -r '.op.account')
    set op_item (echo $account | jq -r '.op.item')
    set op_field (echo $account | jq -r '.op.field')
    set output_file (expand_tilde (echo $account | jq -r '.op.output'))
    set op_vault (echo $account | jq -r '.op.vault')
    set secret_ref "op://$op_vault/$op_item/$op_field"

    set -l op_force_override (test "$force_mode" = true; and echo "--force")

    log info "Downloading public key \"$secret_ref\" to \"$output_file\" from $op_account"
    log debug "     > op read $op_force_override --account \"$op_account\" \"$secret_ref\" --out-file \"$output_file\""

    if test -f $output_file
        if test "$force_mode" = false
            log warn "File already exists: $output_file"
            return 0
        end
        log info "Overwriting existing file: $output_file"
    end

    if not op read $op_force_override --account "$op_account" "$secret_ref" --out-file "$output_file"
        log error "Failed to download public key from 1Password ($op_account): \"$secret_ref\". Please see the install instructions."
        return 1
    end

    # Set permissions for the key
    chmod 600 $output_file
end

function link_1password_ssh_agent_files
    mkdir -p $OP_LINK_DIR
    create_link $OP_SSH_AGENT_SOCKET_PATH $OP_LINK_DIR/agent.sock
    create_link $OP_SSH_AGENT_CONFIG_PATH $OP_LINK_DIR/agent.toml
end

# Check if SSH_AUTH_SOCK or IdentityAgent is configured to 1Password SSH agent
function check_1password_ssh_agent
    if set -q SSH_AUTH_SOCK
        if string match -q '*1password*' $SSH_AUTH_SOCK
            log info "SSH_AUTH_SOCK is set for 1Password."
            return
        end
    end

    if grep -q 'IdentityAgent.*1password' $HOME/.ssh/config
        log info "IdentityAgent is configured for 1Password in $HOME/.ssh/config."
        return
    end

    log error "Neither SSH_AUTH_SOCK is set for 1Password nor IdentityAgent is configured for 1Password in $HOME/.ssh/config. Please see the install instructions."
end

# Execute the functions
#######################

# Read and parse gitconfig.json
log info "Reading $gitconfig_json_path..."
set -l gitconfig_data (read_git_config_json_data $gitconfig_json_path)
log debug "     - gitconfig_data=$gitconfig_data"

log info "Setting up git local main configs..."
setup_git_local_main_configs $gitconfig_data

log info "Configuring accounts..."
configure_accounts $gitconfig_data

log info "Linking 1Password SSH agent files..."
link_1password_ssh_agent_files

log info "Checking if the SSH config is configured to 1Password SSH agent..."
check_1password_ssh_agent
