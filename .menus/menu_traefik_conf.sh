#!/usr/bin/env bash
set -euo pipefail

menu_traefik_conf() {
  local -a OPTIONS
  OPTIONS+=("DOMAIN" "Domain for usage with Traefik reverse proxy.")
  OPTIONS+=("EMAIL_ADDRESS" "Email for usage with Traefik reverse proxy.")

  log 7 "Opening Traefik configuration menu."
  local SELECTION
  SELECTION=$(whiptail --fb --clear --title "media-docker Configuration" \
    --cancel-button "Exit" --menu "Select a traefik item to update." 0 0 0 \
    "${OPTIONS[@]}" 3>&1 1>&2 2>&3 || echo "Exit")

  case $SELECTION in
    "Exit")
      log 7 "Exit selected, returning."
    ;;
    *)
      log 7 "Opening .ENV update menu."
      run_sh "$MENUDIR" "menu_env_update" \
        "$SELECTION" \
        "$(run_sh "$SCRIPTDIR" "env_get" "$SELECTION" "$BASEDIR/.env")"

      run_sh "$MENUDIR" "menu_traefik_conf"
    ;;
  esac
}
