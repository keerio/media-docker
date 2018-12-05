#!/usr/bin/env bash
set -euo pipefail

menu_user() {
  local -a OPTIONS
  OPTIONS+=("USER_NAME" "User name.")
  OPTIONS+=("PASSWORD" "Password.")

  local SELECTION

  SELECTION=$(whiptail --fb --clear --title "media-docker Configuration" \
    --cancel-button "Exit" --menu "Select an item to update." 0 0 0 \
    "${OPTIONS[@]}" 3>&1 1>&2 2>&3 || echo "Exit")

  case $SELECTION in
    "Exit")
      run_sh "$MENUDIR" "menu_manual"
    ;;
    *)
      run_sh "$MENUDIR" "menu_env_update" \
        "$SELECTION" \
        "$(run_sh "$SCRIPTDIR" "env_get" "$SELECTION" "$BASEDIR/.env")" \

      run_sh "$MENUDIR" "menu_user"
      exit
    ;;
  esac
}
