#!/usr/bin/env bash
set -euo pipefail

menu_docker_prune() {
  local PROMPT="Would you like to prune the Docker system?"
  local SELECTION
  local RESPONSE

  SELECTION=$(whiptail --title "media-docker Configuration" \
    --yesno "$PROMPT" 0 0 \
    3>&1 1>&2 2>&3 ; echo $?)
  [ "$SELECTION" -eq 0 ] && RESPONSE="Y" || RESPONSE="N"

  case $RESPONSE in
    [Yy]*)
      info "Starting Docker system prune."
      run_sh "$SCRIPTDIR" "docker_prune"
    ;;
    [Nn]*)
      info "The Docker system will not be pruned."
    ;;
    *)
    ;;
  esac
}
