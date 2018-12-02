#!/usr/bin/env bash
set -euo pipefail

menu_directories() {
  local -a OPTIONS
  OPTIONS+=("BASE_DIR" "Base directory for general storage.")
  OPTIONS+=("MEDIA_DIR" "Base directory for media library.")
  OPTIONS+=("DOWNLOAD_DIR" "Directory for download / swap.")

  local SELECTION

  SELECTION=$(whiptail --fb --clear --title "media-docker Configuration" \
    --cancel-button "Exit" --menu "Select a directory to update." 0 0 0 \
    "${OPTIONS[@]}" 3>&1 1>&2 2>&3 || echo "Exit")

  case $SELECTION in
    "Exit")
    ;;
    *)
      run_sh "$MENUDIR" "menu_env_update" \
        "$SELECTION" \
        "$(run_sh "$SCRIPTDIR" "env_get" "$SELECTION" "$BASEDIR/.env")"

      run_sh "$MENUDIR" "menu_directories"
      exit
    ;;
  esac
}
