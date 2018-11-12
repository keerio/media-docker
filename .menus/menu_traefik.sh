#!/usr/bin/env bash
set -euo pipefail

menu_traefik() {
  local PROMPT="Would you like to overwrite \
    the existing Traefik configuration?"
  local SELECTION
  local RESPONSE
  local DIRECTORY

  DIRECTORY="$(run_sh "$SCRIPTDIR" "env_get" "BASE_DIR")"

  if [[ -f "${DIRECTORY}/traefik/traefik.toml" ]] ; then
    SELECTION=$(whiptail --title "media-docker Configuration" \
      --yesno "$PROMPT" 0 0 \
      3>&1 1>&2 2>&3 ; echo $?)
    [ "$SELECTION" -eq 0 ] && RESPONSE="Y" || RESPONSE="N"
  else
    RESPONSE="Y"
  fi

  case $RESPONSE in
    [Yy]*)
        sudo mkdir -p "${DIRECTORY}/traefik/" \
          > /dev/null 2>&1 || err "Error occured creating Traefik directory."
        sudo cp "$CONFIGDIR/traefik.toml" "$DIRECTORY/traefik/traefik.toml" \
          > /dev/null 2>&1 || err "Error occured copying traefik.toml."
        sudo touch "${DIRECTORY}/traefik/acme.json" \
          > /dev/null 2>&1 || err "Error occured creating acme.json."
        sudo chmod 600 "${DIRECTORY}/traefik/acme.json" \
          > /dev/null 2>&1 || err "Error occured creating acme.json."
    ;;
    *)
    ;;
  esac

  run_sh "$SCRIPTDIR" "editor_open" "${DIRECTORY}/traefik/traefik.toml"
}
