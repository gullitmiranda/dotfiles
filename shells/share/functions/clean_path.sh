#!/usr/bin/env sh
# shellcheck disable=SC3043

# Function to clean PATH by removing non-existent directories
clean_path() {
	local new_path=""
	local dir
	for dir in $(echo "${PATH}" | tr ':' ' '); do
		if [ -d "${dir}" ]; then
			if [ -z "${new_path}" ]; then
				new_path="${dir}"
			else
				new_path="${new_path}:${dir}"
			fi
		fi
	done
	export PATH="${new_path}"
}

# Run clean_path when sourced
clean_path
