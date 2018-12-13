#!/usr/bin/env bash
set -euo pipefail

menu_traefik() {
  local PROMPT="Would you like to overwrite \
    the existing Traefik configuration?"
  local RESPONSE

  log 7 "Loading base directory from .ENV."
  local DIRECTORY
  DIRECTORY="$(run_sh "$SCRIPTDIR" "env_get" "CONTAINER_DIR")"

  log 7 "Checking if traefik.toml already exists."
  if [[ -f "${DIRECTORY}/traefik/traefik.toml" ]] ; then

    log 7 "Prompting decision on traefik.toml overwrite."
    local SELECTION
    SELECTION=$(whiptail --title "media-docker Configuration" \
      --yesno "$PROMPT" 0 0 \
      3>&1 1>&2 2>&3 ; echo $?)
    [ "$SELECTION" -eq 0 ] && RESPONSE="Y" || RESPONSE="N"
  else
    RESPONSE="Y"
  fi

  case $RESPONSE in
    [Yy]*)
      log 6 "Ensuring Traefik directory exists."
      sudo mkdir -p "${DIRECTORY}/traefik/" \
        > /dev/null 2>&1 || log 3 "Error occured creating Traefik directory."

      log 6 "Ensuring acme.json exists."
      sudo touch "${DIRECTORY}/traefik/acme.json" \
        > /dev/null 2>&1 || log 6 "Error occured creating acme.json."

      log 6 "Setting permissions for acme.json to 0600."
      sudo chmod 600 "${DIRECTORY}/traefik/acme.json" \
        > /dev/null 2>&1 || log 3 "Error occured creating acme.json."

      log 7 "Opening Traefik TOML menu."
      run_sh "$MENUDIR" "menu_traefik_toml"
    ;;
    *)
    ;;
  esac

  log 6 "Running docker-compose creation process."
  run_sh "$SCRIPTDIR" "compose_create"

  log 7 "Opening traefik.toml in editor."
  run_sh "$SCRIPTDIR" "editor_open" "${DIRECTORY}/traefik/traefik.toml"

  log 7 "Returning to configuration menu."
  run_sh "$MENUDIR" "menu_manual"
  exit
}
