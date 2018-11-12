#!/usr/bin/env bash
set -euo pipefail

menu_timezone() {
  local CURRTZ
  local -a TIMEZONES
  local -a OPTIONS

  TIMEZONES=$(run_sh "$SCRIPTDIR" "timezone_list")
  CURRTZ=$(run_sh "$SCRIPTDIR" "timezone_get")

  for tz in $TIMEZONES ; do
    if [ "$tz" = "$CURRTZ" ] ; then
      OPTIONS=("${OPTIONS[@]}" "$tz" "" "ON")
    else
      OPTIONS=("${OPTIONS[@]}" "$tz" "" "OFF")
    fi
  done

  SELECTION=$(whiptail --title "media-docker Configuration" --radiolist \
    "Select the desired timezone." 0 0 0 \
    "${OPTIONS[@]}" 3>&1 1>&2 2>&3 || echo "$CURRTZ")

  case $SELECTION in
    *)
      run_sh "$SCRIPTDIR" "env_set" "TIMEZONE" "$SELECTION" ".env"
      run_sh "$SCRIPTDIR" "timezone_set" "$SELECTION"
    ;;
  esac
}
