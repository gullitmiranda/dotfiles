# OpenTofu aliases with optional logging
# tf* aliases point to OpenTofu; use `terraform` directly for the official binary
# Usage: tf plan --log    -> logs to ./logs/tofu-plan-YYYY-MM-DD-HHMMSS.log

# Helper function to run command with optional logging
_tf_run() {
	local cmd="$1"
	local subcmd="$2"
	shift 2

	local log_flag=false
	local args=()

	# Parse arguments, extract --log or -l flag
	for arg in "$@"; do
		case "${arg}" in
		--log | -l) log_flag=true ;;
		*) args+=("${arg}") ;;
		esac
	done

	if [[ ${log_flag} == true ]]; then
		local timestamp=$(date +%Y-%m-%d-%H%M%S)
		local log_dir="./logs"
		local log_file="${log_dir}/${cmd}-${subcmd}-${timestamp}.log"

		mkdir -p "${log_dir}"
		echo "Logging to: ${log_file}"
		"${cmd}" "${subcmd}" "${args[@]}" 2>&1 | tee "${log_file}"
	else
		"${cmd}" "${subcmd}" "${args[@]}"
	fi
}

# tf* aliases -> OpenTofu
tf() { tofu "$@"; }
tfplan() { _tf_run tofu plan "$@"; }
tfapply() { _tf_run tofu apply "$@"; }
tfinit() { _tf_run tofu init "$@"; }
tfdestroy() { _tf_run tofu destroy "$@"; }

# OpenTofu aliases
tfu() { tofu "$@"; }
tfuplan() { _tf_run tofu plan "$@"; }
tfuapply() { _tf_run tofu apply "$@"; }
tfuinit() { _tf_run tofu init "$@"; }
tfudestroy() { _tf_run tofu destroy "$@"; }
