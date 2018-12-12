#!/usr/bin/env bash
set -euo pipefail

menu_vpn() {
  local -a OPTIONS
  OPTIONS+=("VPN_PROVIDER" "VPN service provider.")
  OPTIONS+=("VPN_USER" "User name for VPN service.")
  OPTIONS+=("VPN_PASS" "Password for VPN service.")

  log 7 "Opening VPN menu."
  local SELECTION
  SELECTION=$(whiptail --fb --clear --title "media-docker Configuration" \
    --cancel-button "Exit" --menu "Select an item to update." 0 0 0 \
    "${OPTIONS[@]}" 3>&1 1>&2 2>&3 || echo "Exit")

  case $SELECTION in
    "Exit")
      log 7 "Exit selected, returning to config menu."
      run_sh "$MENUDIR" "menu_manual"
    ;;
    *)
      log 7 "Opening .ENV update menu."
      run_sh "$MENUDIR" "menu_env_update" \
        "$SELECTION" \
        "$(run_sh "$SCRIPTDIR" "env_get" "$SELECTION" "$BASEDIR/.env")" \

      run_sh "$MENUDIR" "menu_vpn"
      exit
    ;;
  esac
}
