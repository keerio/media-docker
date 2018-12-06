#!/usr/bin/env bash
set -euo pipefail

menu_traefik_auth() {
  local PROMPT="Would you like to use \
    Traefik basic authentication for all enabled services?"
  local SELECTION
  local RESPONSE

  SELECTION=$(whiptail --title "media-docker Configuration" \
    --yesno "$PROMPT" 0 0 \
    3>&1 1>&2 2>&3 ; echo $?)
  [ "$SELECTION" -eq 0 ] && RESPONSE="Y" || RESPONSE="N"

  run_sh "$SCRIPTDIR" "env_set" "TRAEFIK_AUTH" "$RESPONSE" "$BASEDIR/.env"
}
