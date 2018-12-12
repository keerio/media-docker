#!/usr/bin/env bash
set -euo pipefail

menu_main() {
  local -a OPTIONS
  OPTIONS+=("Configuration" "Manually perform configuration and installation.")
  OPTIONS+=("Update" "Update files from GitHub.")
  OPTIONS+=("Docker Prune" "Cleanup Docker system.")
  OPTIONS+=(".ENV" "View or edit .env.")
  OPTIONS+=(".APPS" "View or edit .apps.")

  log 7 "Opening main menu."
  local SELECTION
  SELECTION=$(whiptail --fb --clear --title "media-docker Configuration" \
    --cancel-button "Exit" --menu "Select an option." 0 0 0 \
    "${OPTIONS[@]}" 3>&1 1>&2 2>&3 || echo "Exit")

  case $SELECTION in
    "Configuration")
      log 6 "Starting application configuration process."
      run_sh "$MENUDIR" "menu_manual" || run_sh "$MENUDIR" "menu_main"
    ;;
    "Update")
      log 6 "Starting media-docker update process."
      run_sh "$MENUDIR" "menu_update" "${BASEDIR}" \
        || run_sh "$MENUDIR" "menu_main"
    ;;
    "Docker Prune")
      log 6 "Asking for confirmation of Docker system prune."
      run_sh "$MENUDIR" "menu_docker_prune" \
        || run_sh "$MENUDIR" "menu_main"
    ;;
    ".ENV")
      log 6 "Opening .env."
      run_sh "$SCRIPTDIR" "editor_open" "${BASEDIR}/.env" \
        || run_sh "$MENUDIR" "menu_main"
    ;;
    ".APPS")
      log 6 "Opening .apps."
      run_sh "$SCRIPTDIR" "editor_open" "${BASEDIR}/.apps" \
        || run_sh "$MENUDIR" "menu_main"
    ;;
    *)
      log 7 "Exiting media-docker."
      return 0
    ;;
  esac
}
