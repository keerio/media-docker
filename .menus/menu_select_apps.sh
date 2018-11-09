#!/usr/bin/env bash
set -euo pipefail

menu_select_apps() {
  local -a APPS
  local -a OPTIONS
  local -a SELECTIONS
  local -A MAPSELS
  
  APPS=$(run_sh "$SCRIPTDIR" "dir_array" "$CONTAINDIR")

  if [[ ! -f "${BASEDIR}/.apps" ]]
  then
    echo "# APP CONFIGURATION" >> "${BASEDIR}/.apps"
  fi

  for app in $APPS ; do
    local DESC
    DESC=$(cat "$CONTAINDIR/$app/.description")
    OPTIONS=("${OPTIONS[@]}" "$app" "$DESC" ON)
  done

  # get user input
  SELECTIONS=$(whiptail --title "media-docker Configuration" --checklist \
    "Enable or disable applications" 0 0 0 \
    "${OPTIONS[@]}" 3>&1 1>&2 2>&3 || echo "Exit")
  # replace pesky quotes
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