#!/usr/bin/env bash
set -euo pipefail

menu_update() {
  local PROMPT="Would you like to update the media-docker system?"
  local SELECTION
  local RESPONSE
  local DIRECTORY

  DIRECTORY=${1:-}
  SELECTION=$(whiptail --title "media-docker Configuration" --yesno "$PROMPT" 0 0 \
    3>&1 1>&2 2>&3 ; echo $?)
  [ $SELECTION -eq 0 ] && RESPONSE="Y" || RESPONSE="N"
  
  case $RESPONSE in
    [Yy]*)
      info "Starting media-docker self update."
      run_sh "$SCRIPTDIR" "self_update" "$DIRECTORY"
    ;;
    [Nn]*)
      info "The media-docker self update will not be run."
    ;;
    *)
    ;;
  esac
}