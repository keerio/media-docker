#!/usr/bin/env bash
set -euo pipefail

menu_directories() {
  local -a OPTIONS
  OPTIONS+=("BASE_DIR" "Base directory for general storage.")
  OPTIONS+=("MEDIA_DIR_MOVIES" "Base directory for movies.")
  OPTIONS+=("MEDIA_DIR_MUSIC" "Base directory for music.")
  OPTIONS+=("MEDIA_DIR_TV" "Base directory for TV.")
  OPTIONS+=("MEDIA_DIR_BOOKS" "Base directory for books.")
  OPTIONS+=("MEDIA_DIR_COMICS" "Base directory for comics.")
  OPTIONS+=("DOWNLOAD_DIR" "Directory for download / swap.")

  log 7 "Opening directory configuration menu."
  local SELECTION
  SELECTION=$(whiptail --fb --clear --title "media-docker Configuration" \
    --cancel-button "Exit" --menu "Select a directory to update." 0 0 0 \
    "${OPTIONS[@]}" 3>&1 1>&2 2>&3 || echo "Exit")

  case $SELECTION in
    "Exit")
      log 7 "Exit selected, returning."
      run_sh "$MENUDIR" "menu_manual"
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
