# Terraform/OpenTofu aliases with optional logging
# Usage: tfu plan --log    -> logs to ./logs/tofu-plan-YYYY-MM-DD-HHMMSS.log
#        tf apply --log    -> logs to ./logs/terraform-apply-YYYY-MM-DD-HHMMSS.log

# Helper function to run command with optional logging
_tf_run() {
	local cmd="$1"
	local subcmd="$2"
	shift 2

	local log_flag=false
	local args=()

	# Parse arguments, extract --log or -l flag
	for arg in "$@"; do
		case "$arg" in
		--log | -l) log_flag=true ;;
		*) args+=("$arg") ;;
		esac
	done

	if [[ $log_flag == true ]]; then
		local timestamp=$(date +%Y-%m-%d-%H%M%S)
		local log_dir="./logs"
		local log_file="${log_dir}/${cmd}-${subcmd}-${timestamp}.log"

		mkdir -p "$log_dir"
		echo "Logging to: $log_file"
		"$cmd" "$subcmd" "${args[@]}" 2>&1 | tee "$log_file"
	else
		"$cmd" "$subcmd" "${args[@]}"
	fi
}

# OpenTofu aliases
tfu() { tofu "$@"; }
tfuplan() { _tf_run tofu plan "$@"; }
tfuapply() { _tf_run tofu apply "$@"; }
tfuinit() { _tf_run tofu init "$@"; }
tfudestroy() { _tf_run tofu destroy "$@"; }

# Terraform aliases
tf() { terraform "$@"; }
tfplan() { _tf_run terraform plan "$@"; }
tfapply() { _tf_run terraform apply "$@"; }
tfinit() { _tf_run terraform init "$@"; }
tfdestroy() { _tf_run terraform destroy "$@"; }
