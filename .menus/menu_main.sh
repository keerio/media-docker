#!/usr/bin/env bash
set -euo pipefail

menu_main() {
  local -a OPTIONS
  OPTIONS+=("Configuration" "Manually perform configuration and installation.")
  OPTIONS+=("Update" "Update files from GitHub.")
  OPTIONS+=("Docker Prune" "Cleanup Docker system.")
  OPTIONS+=(".ENV" "View or edit .env.")
  OPTIONS+=(".APPS" "View or edit .apps.")

  local SELECTION

  SELECTION=$(whiptail --fb --clear --title "media-docker Configuration" \
    --cancel-button "Exit" --menu "Select an option." 0 0 0 \
    "${OPTIONS[@]}" 3>&1 1>&2 2>&3 || echo "Exit")

  case $SELECTION in
    "Configuration")
      info "Starting manual app configuration process."
      run_sh "$MENUDIR" "menu_manual" || run_sh "$MENUDIR" "menu_main"
    ;;
    "Update")
      info "Starting media-docker update process."
      run_sh "$MENUDIR" "menu_update" "${BASEDIR}" \
        || run_sh "$MENUDIR" "menu_main"
    ;;
    "Docker Prune")
      info "Asking for confirmation of Docker system prune."
      run_sh "$MENUDIR" "menu_docker_prune" \
        || run_sh "$MENUDIR" "menu_main"
    ;;
    ".ENV")
      info "Opening .env."
      run_sh "$SCRIPTDIR" "editor_open" "${BASEDIR}/.env" \
        || run_sh "$MENUDIR" "menu_main"
    ;;
    ".APPS")
      info "Opening .apps."
      run_sh "$SCRIPTDIR" "editor_open" "${BASEDIR}/.apps" \
        || run_sh "$MENUDIR" "menu_main"
    ;;
    *)
      return 0
    ;;
  esac
}
