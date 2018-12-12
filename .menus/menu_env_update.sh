#!/usr/bin/env bash
set -euo pipefail

menu_env_update() {
  local PROMPT
  local KEY
  local VAL

  KEY=${1:-}
  VAL=${2:-}
  PROMPT="Update value for ${KEY}."

  log 7 "Prompting for update of ${KEY}."
  VAL=$(whiptail --title "Update .env" --inputbox "$PROMPT" 0 0 "$VAL" \
    3>&1 1>&2 2>&3 || echo "Exit" )
  if [ "$VAL" != "Exit" ]; then
    run_sh "$SCRIPTDIR" "env_set" "$KEY" "$VAL"
  else
    return $?
  fi
}
