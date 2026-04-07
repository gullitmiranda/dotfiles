#!/usr/bin/env bash

# Sync iTerm2 preferences between local plist and iCloud.
# Strategies: newest (default), local, icloud.
# Override via: --strategy=<value>, ITERM_SYNC_STRATEGY env, or config.yaml iterm.sync_strategy.

set -euo pipefail

### Config

ICLOUD_ITERM_DIR="${HOME}/Library/Mobile Documents/com~apple~CloudDocs/iTerm2"
LOCAL_PLIST="${HOME}/Library/Preferences/com.googlecode.iterm2.plist"
ICLOUD_PLIST="${ICLOUD_ITERM_DIR}/com.googlecode.iterm2.plist"

config_strategy="${ITERM_CONFIG_STRATEGY:-newest}"
strategy="${ITERM_SYNC_STRATEGY:-${config_strategy}}"

for arg in "$@"; do
	case "${arg}" in
	--strategy=*) strategy="${arg#--strategy=}" ;;
	*) ;;
	esac
done

### Helpers

log() {
	local level="${1}"
	local msg="${2}"
	echo "${level}: ${msg}"
}

timestamp_of() {
	if [[ -f $1 ]]; then
		stat -f '%m' "$1"
	else
		echo "0"
	fi
}

backup_plist() {
	local src="${1}"
	local backup
	backup="${src}.backup.$(date +%Y%m%d%H%M%S)"
	if [[ -f ${src} ]]; then
		cp "${src}" "${backup}"
		log info "Backed up ${src} → ${backup}"
	fi
}

### Strategies

sync_newest() {
	local local_ts icloud_ts
	local_ts="$(timestamp_of "${LOCAL_PLIST}")"
	icloud_ts="$(timestamp_of "${ICLOUD_PLIST}")"

	if [[ ${local_ts} -eq 0 && ${icloud_ts} -eq 0 ]]; then
		log info "No existing preferences found — iTerm2 will start fresh"
	elif [[ ${local_ts} -gt ${icloud_ts} ]]; then
		log info "Local prefs are newer — pushing to iCloud"
		backup_plist "${ICLOUD_PLIST}"
		cp "${LOCAL_PLIST}" "${ICLOUD_PLIST}"
	elif [[ ${icloud_ts} -gt ${local_ts} ]]; then
		log info "iCloud prefs are newer — will be loaded by iTerm2"
	else
		log info "Prefs are in sync"
	fi
}

sync_local() {
	if [[ ! -f ${LOCAL_PLIST} ]]; then
		log warn "No local plist found at ${LOCAL_PLIST} — nothing to push"
		return
	fi
	backup_plist "${ICLOUD_PLIST}"
	cp "${LOCAL_PLIST}" "${ICLOUD_PLIST}"
	log info "Pushed local prefs to iCloud"
}

sync_icloud() {
	if [[ -f ${ICLOUD_PLIST} ]]; then
		log info "iCloud prefs found — will be loaded by iTerm2"
	elif [[ -f ${LOCAL_PLIST} ]]; then
		log info "No iCloud prefs — pushing local as initial seed"
		cp "${LOCAL_PLIST}" "${ICLOUD_PLIST}"
	else
		log info "No existing preferences found — iTerm2 will start fresh"
	fi
}

### Execute

mkdir -p "${ICLOUD_ITERM_DIR}"

log info "Sync strategy: ${strategy}"

case "${strategy}" in
newest) sync_newest ;;
local) sync_local ;;
icloud) sync_icloud ;;
*)
	log error "Unknown strategy: ${strategy} (expected: newest, local, icloud)"
	exit 1
	;;
esac

# Point iTerm2 to iCloud folder and enable auto-save
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "${ICLOUD_ITERM_DIR}"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLostForFile -bool true
defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLostForFile_selection -int 2

log info "iTerm2 configured to sync preferences from iCloud (auto-save enabled)"
log info "Done."
