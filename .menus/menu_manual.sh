#!/usr/bin/env bash
set -euo pipefail

menu_manual() {
  local -a OPTIONS
  OPTIONS+=("Install Prerequisites" "Install necessary packages and repositories.")
  OPTIONS+=("Directories" "Define / update storage directories.")
  OPTIONS+=("Apps" "Enable or disable applications.")
  OPTIONS+=("Traefik" "Edit Traefik configuration.")
  OPTIONS+=("VPN Torrent" "Edit VPN torrenting configuration.")
  OPTIONS+=("Timezone" "Set timezone.")
  OPTIONS+=("Plex Claim" "Set Plex claim token.")
  OPTIONS+=("Start" "Start Docker containers.")

  local SELECTION
  
  SELECTION=$(whiptail --fb --clear --title "media-docker Configuration" \
    --cancel-button "Exit" --menu "Select an option." 0 0 0 \
    "${OPTIONS[@]}" 3>&1 1>&2 2>&3 || echo "Exit")

  case $SELECTION in
    "Install Prerequisites")
      info "Starting prerequistes install."
      run_sh "$SCRIPTDIR" "apt_prereqs_install"
    ;;
    "Directories")
      info "Starting directory configuration process."
      run_sh "$MENUDIR" "menu_directories"
    ;;
    "Apps")
      info "Starting manual app configuration process."
      run_sh "$MENUDIR" "menu_apps"
    ;;
    "Traefik")
      info "Starting Traefik configuration process."
      run_sh "$MENUDIR" "menu_traefik"
    ;;
    "VPN Torrent")
      info "Starting Torrent-over-VPN configuration process."
      run_sh "$MENUDIR" "menu_vpn"
    ;;
    "Timezone")
      info "Starting timezone update process."
      run_sh "$MENUDIR" "menu_timezone"
    ;;
    "Plex Claim")
      info "Starting Plex claim process."
      run_sh "$MENUDIR" "menu_env_update" \
        "PLEX_CLAIM_TOKEN" \
        $(run_sh "$SCRIPTDIR" "env_get" "PLEX_CLAIM_TOKEN" "$BASEDIR/.env") \
        "$BASEDIR/.env"
    ;;
    "Start")
      info "Starting Docker containers."
      run_sh "$SCRIPTDIR" "compose_up"
    ;;
    *)
      run_sh "$MENUDIR" "menu_main"
    ;;
  esac
}