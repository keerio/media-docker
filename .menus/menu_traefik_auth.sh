#!/usr/bin/env bash
set -euo pipefail

menu_traefik_auth() {
  local PROMPT="Would you like to use \
    Traefik basic authentication for all enabled services?"
  local RESPONSE

  log 7 "Prompting decision on Traefik basic authentication."
  local SELECTION
  SELECTION=$(whiptail --title "media-docker Configuration" \
    --yesno "$PROMPT" 0 0 \
    3>&1 1>&2 2>&3 ; echo $?)
  [ "$SELECTION" -eq 0 ] && RESPONSE="Y" || RESPONSE="N"

  log 6 "Setting Traefik auth file in traefik.toml."
  run_sh "$SCRIPTDIR" "env_set" "TRAEFIK_AUTH" "$RESPONSE" "$BASEDIR/.env"
}
