#!/usr/bin/env bash
# shellcheck disable=SC2207
set -euo pipefail

menu_le_provider() {
  local -a PROVIDERS
  local -a OPTIONS
  local SEL_PROVIDER

  PROVIDERS=($(run_sh "$SCRIPTDIR" \
    "env_list_keys" "${CONFIGDIR}/.dnsProviders"))

  for provider in "${PROVIDERS[@]}" ; do
    log 7 "Reading available options for provider: ${provider}."
    OPTIONS=("${OPTIONS[@]}" "$provider" "$provider")
  done

  log 7 "Opening Let's Encrypt provider selection menu."
  local SELECTION
  SELECTION=$(whiptail --fb --clear --title "media-docker Configuration" \
    --cancel-button "Exit" \
    --menu "Select a Let's Encrypt DNS provider." 0 0 0 \
    "${OPTIONS[@]}" 3>&1 1>&2 2>&3 || echo "Exit")

  case $SELECTION in
    "Exit")
      log 7 "Exit selected, returning."
    ;;
    *)
      run_sh "$SCRIPTDIR" "env_set" \
        "LE_CHLG_PROV" "$SELECTION" "$BASEDIR/.env"

      SEL_PROVIDER=$(run_sh "$SCRIPTDIR" "env_get" \
        "LE_CHLG_PROV" "$BASEDIR/.env")

      log 7 "Opening Let's Encrypt configuration menu for: ${SEL_PROVIDER}"
      run_sh "$MENUDIR" "menu_le_provider_config" "$SEL_PROVIDER"
    ;;
  esac
}
