#!/usr/bin/env bash
set -euo pipefail

menu_select_apps() {
  local -a APPS
  local -a OPTIONS
  local -a SELECTIONS
  local -A MAPSELS
  local APPENV="${BASEDIR}/.apps"

  APPS=$(run_sh "$SCRIPTDIR" "dir_array" "$CONTAINDIR")

  if [[ ! -f "${BASEDIR}/.apps" ]]
  then
    echo "# APP CONFIGURATION" >> "$APPENV"
  fi

  for app in $APPS ; do
    local DESC
    local ENABLED

    # pull description of app from file
    DESC=$(cat "$CONTAINDIR/$app/.description")
    # determine if app has been enabled before
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

  # get user input
  SELECTIONS=$(whiptail --title "media-docker Configuration" --checklist \
    "Enable or disable applications" 0 0 0 \
    "${OPTIONS[@]}" 3>&1 1>&2 2>&3 || echo "Exit")
  
  # replace pesky quotes and map to associative array
  SELECTIONS=("${SELECTIONS[@]//\"/}")
  for SELECTION in $SELECTIONS ; do
    MAPSELS["$SELECTION"]=1
  done

  case $SELECTIONS in
    *)
      for APP in ${APPS[@]} ; do
        if [[ ${MAPSELS[$APP]+_} ]]
        then
          run_sh "$SCRIPTDIR" "env_set" "$APP" "Y" ".apps"
        else
          run_sh "$SCRIPTDIR" "env_set" "$APP" "N" ".apps"
        fi
      done

      run_sh "$MENUDIR" "menu_main"
    ;;
  esac
}