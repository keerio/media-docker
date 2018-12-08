#!/usr/bin/env bash
# shellcheck disable=SC2068
# shellcheck disable=SC2207
set -euo pipefail

menu_le_provider_config() {
  local PROVIDER
  local -a PROVIDER_VARS
  local -a OPTIONS

  PROVIDER=${1:-}

  IFS='|' read -r -a PROVIDER_VARS \
    <<< "$(run_sh "$SCRIPTDIR" \
      "env_get" "$PROVIDER" "$CONFIGDIR/.dnsProviders")"

  for var in ${PROVIDER_VARS[@]} ; do
    OPTIONS+=("${var}" "${var}")
  done

  local SELECTION
  SELECTION=$(whiptail --fb --clear --title "media-docker Configuration" \
    --cancel-button "Back" --menu "Select an option to update." 0 0 0 \
    "${OPTIONS[@]}" 3>&1 1>&2 2>&3 || echo "Back")

  case $SELECTION in
    "Back")
      run_sh "$MENUDIR" "menu_le_provider"
    ;;
    *)
      run_sh "$MENUDIR" "menu_env_update" \
        "$SELECTION" \
        "$(run_sh "$SCRIPTDIR" "env_get" "$SELECTION" "$BASEDIR/.env")"

      run_sh "$MENUDIR" "menu_le_provider_config" "$PROVIDER"
      exit
    ;;
  esac
}