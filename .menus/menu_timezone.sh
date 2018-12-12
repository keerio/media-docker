#!/usr/bin/env bash
set -euo pipefail

menu_timezone() {
  local HOST_TZ
  local ENV_TZ
  local SELECT_TZ
  local -a OPTIONS

  HOST_TZ=$(run_sh "$SCRIPTDIR" "timezone_get")
  ENV_TZ=$(run_sh "$SCRIPTDIR" "env_get" "TIMEZONE")

  OPTIONS+=("Use Current Host Value " "${HOST_TZ}")
  OPTIONS+=("Use Current .ENV Value " "${ENV_TZ}")
  OPTIONS+=("New Value " "Select New Timezone")

  log 7 "Opening timezone selection menu."
  local SELECTION
  SELECTION=$(whiptail --fb --clear --title "media-docker Configuration" \
    --cancel-button "Exit" \
    --menu "Select a timezone option." 0 0 0 \
    "${OPTIONS[@]}" 3>&1 1>&2 2>&3 || echo "Exit")

  case $SELECTION in
    "Exit")
      log 6 "Exit selected, using current host value."
      SELECT_TZ="$HOST_TZ"
    ;;
    "Use Current Host Value ")
      log 6 "Using current host value."
      SELECT_TZ="$HOST_TZ"
    ;;
    "Use Current .ENV Value ")
      log 6 "Using current .ENV value."
      SELECT_TZ="$ENV_TZ"
    ;;
    "New Value ")
      log 6 "Selecting new value from list."
      SELECT_TZ=$(run_sh "$MENUDIR" "menu_timezone_list")
    ;;
  esac

  run_sh "$SCRIPTDIR" "env_set" "TIMEZONE" "$SELECT_TZ" ".env"
  run_sh "$SCRIPTDIR" "timezone_set" "$SELECT_TZ"

  log 7 "Returning to configuration menu."
  run_sh "$MENUDIR" "menu_manual"
}