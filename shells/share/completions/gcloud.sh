if ! command -v mise >/dev/null 2>&1; then
	return 0
fi

if mise where gcloud >/dev/null 2>&1; then
	# shellcheck source=/dev/null disable=SC2312
	source "$(mise where gcloud)/completion.${SHELL_TYPE}.inc"
fi
