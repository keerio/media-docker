#!/usr/bin/env bash
set -euo pipefail

menu_le_challenge_select() {
  local -a OPTIONS
  OPTIONS+=("http" "HTTP request challenge")
  OPTIONS+=("dns" "DNS request challenge")

  local SELECTION
  SELECTION=$(whiptail --fb --clear --title "media-docker Configuration" \
    --cancel-button "Exit" \
    --menu "Select a Let's Encrypt challenge type." 0 0 0 \
    "${OPTIONS[@]}" 3>&1 1>&2 2>&3 || echo "Exit")

  case $SELECTION in
    "Exit")
      run_sh "$MENUDIR" "menu_manual"
    ;;
    "http")
      run_sh "$SCRIPTDIR" "toml_write" \
        "$FILE" "acme.httpChallenge.entryPoint" "https"
    ;;
    "dns")
      run_sh "$MENUDIR" "menu_le_provider"

      PROVIDER=$(run_sh "$SCRIPTDIR" "env_get" "LE_CHLG_PROV")

      run_sh "$SCRIPTDIR" "toml_write" \
        "$FILE" "acme.dnsChallenge" "$PROVIDER"
    ;;
  esac
}