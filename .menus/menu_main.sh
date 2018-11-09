#!/usr/bin/env bash
set -euo pipefail

menu_main() {
  local -a OPTIONS
  OPTIONS+=("Guided Installer" "Walk through configuration and installation.")
  OPTIONS+=("Select Apps" "Enable or disable applications.")
  OPTIONS+=("Timezone" "Set timezone.")
  OPTIONS+=("Update" "Update files from GitHub.")
  OPTIONS+=("Docker Prune" "Cleanup Docker system.")

  local SELECTION
  
  SELECTION=$(whiptail --fb --clear --title "media-docker Configuration" \
    --cancel-button "Exit" --menu "Select an option." 0 0 0 \
    "${OPTIONS[@]}" 3>&1 1>&2 2>&3 || echo "Exit")

  case $SELECTION in
    "Guided Installer")
      info "Starting guided installer process."
      run_sh "$MENUDIR" "menu_guided" || run_sh "$MENUDIR" "menu_main"
    ;;
    "Select Apps")
      info "Starting manual app configuration process."
      run_sh "$MENUDIR" "menu_apps" || run_sh "$MENUDIR" "menu_main"
    ;;
    "Timezone")
      info "Starting timezone update process."
      run_sh "$MENUDIR" "menu_timezone" || run_sh "$MENUDIR" "menu_main"
    ;;
    "Update")
      info "Starting media-docker update process."
      run_sh "$MENUDIR" "menu_update" ${BASEDIR} || run_sh "$MENUDIR" "menu_main"
    ;;
    "Docker Prune")
      info "Asking for confirmation of Docker system prune."
      run_sh "$MENUDIR" "menu_docker_prune" || run_sh "$MENUDIR" "menu_main"
    ;;
    "Exit")
      return
    ;;
    *)
      run_sh "$MENUDIR" "menu_main"
    ;;
  esac
}