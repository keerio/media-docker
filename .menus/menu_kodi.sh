#!/usr/bin/env bash
set -euo pipefail

menu_kodi() {
  local -a OPTIONS
  OPTIONS+=("MARIADB_ROOT_PASSWORD" "Root password for MariaDB.")
  OPTIONS+=("MARIADB_DATABASE" "Database name for MariaDB.")
  OPTIONS+=("MARIADB_USER" "User name for MariaDB.")
  OPTIONS+=("MARIADB_PASSWORD" "Password for MariaDB.")

  log 7 "Opening MariaDB menu."
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

      run_sh "$MENUDIR" "menu_kodi"
      exit
    ;;
  esac
}
