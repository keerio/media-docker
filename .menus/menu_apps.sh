#!/usr/bin/env bash
# shellcheck disable=SC2068
set -euo pipefail

menu_apps() {
  local -a APPS
  local -a OPTIONS
  local -a SELECTIONS
  local -A MAPSELS
  local APPENV="${BASEDIR}/.apps"

  APPS=$(run_sh "$SCRIPTDIR" "dir_array" "$CONTAINDIR")

  if [[ ! -f "$APPENV" ]] ; then
    log 6 ".APPS not found, creating."
    echo "# APP CONFIGURATION" >> "$APPENV"
  fi

  for app in $APPS ; do
    local DESC
    local ENABLED

    log 7 "Reading description of ${app} from file."
    DESC=$(cat "$CONTAINDIR/$app/.description")

    log 7 "Checking if ${app} has been previously enabled."
    ENABLED=$(run_sh "$SCRIPTDIR" "env_get" "$app" "$APPENV" || echo "N")
    case $ENABLED in
      [Yy]*)
        ENABLED=ON
      ;;
      *)
        ENABLED=OFF
      ;;
    esac

    OPTIONS=("${OPTIONS[@]}" \
      "$app" "$DESC" "$ENABLED")
  done

  log 7 "Opening application enable menu."
  SELECTIONS=$(whiptail --title "media-docker Configuration" --checklist \
    "Enable or disable applications" 0 0 0 \
    "${OPTIONS[@]}" 3>&1 1>&2 2>&3 || echo "Exit")

  log 7 "Mapping apps to associative array."
  SELECTIONS=("${SELECTIONS[@]//\"/}")
  for SELECTION in ${SELECTIONS[@]} ; do
    MAPSELS["$SELECTION"]=1
  done

  log 6 "Enabling / disabling apps."
  for APP in ${APPS[@]} ; do
    if [[ ${MAPSELS[$APP]+_} ]] ; then
      log 7 "Enabled app: ${APP}."
      run_sh "$SCRIPTDIR" "env_set" "$APP" "Y" ".apps"
    else
      log 7 "Disabled app: ${APP}."
      run_sh "$SCRIPTDIR" "env_set" "$APP" "N" ".apps"
    fi
  done

  log 6 "Checking prerequisite apps."
  if [[ $(run_sh "$SCRIPTDIR" "env_get" "kodi-headless" "$APPENV" \
    || echo "N") == "Y" ]] ; then
    log 7 "Ensuring mariadb is enabled for kodi-headless."
    run_sh "$SCRIPTDIR" "env_set" "mariadb" "Y" ".apps"
  fi

  log 6 "Running docker-compose creation process."
  run_sh "$SCRIPTDIR" "compose_create"

  log 7 "Returning to configuration menu."
  run_sh "$MENUDIR" "menu_manual"
}
