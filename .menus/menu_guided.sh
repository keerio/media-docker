#!/usr/bin/env bash
set -euo pipefail

menu_guided() {
  info "Starting prerequistes install."
  run_sh "$SCRIPTDIR" "prereq_install"

  info "Starting timezone update process."
  run_sh "$MENUDIR" "menu_timezone"

  info "Starting directory configuration process."
  run_sh "$MENUDIR" "menu_directories"

  info "Starting manual app configuration process."
  run_sh "$MENUDIR" "menu_apps"

  if [[ $(run_sh "$SCRIPTDIR" "app_is_active" "traefik") -eq 0 ]] ; then
    info "Starting Traefik configuration process."
    run_sh "$MENUDIR" "menu_traefik"
  fi

  if [[ $(run_sh "$SCRIPTDIR" "app_is_active" "torrenting")  -eq 0 ]] ; then
    info "Starting Torrent-over-VPN configuration process."
    run_sh "$MENUDIR" "menu_vpn"
  fi

  if [[ $(run_sh "$SCRIPTDIR" "app_is_active" "plex")  -eq 0 ]] ; then
    info "Starting Plex claim process."
    run_sh "$MENUDIR" "menu_env_update" \
      "PLEX_CLAIM_TOKEN" \
      "$(run_sh "$SCRIPTDIR" "env_get" "PLEX_CLAIM_TOKEN" "$BASEDIR/.env")" \
      "$BASEDIR/.env"
  fi

  info "Starting Docker containers."
  run_sh "$SCRIPTDIR" "compose_up"

  run_sh "$MENUDIR" "menu_main"
  exit
}
