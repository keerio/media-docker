#!/usr/bin/env bash
set -euo pipefail

menu_select_apps() {
  local -a APPS
  local -a OPTIONS
  
  APPS=$(run_sh "$SCRIPTDIR" "dir_array" "$CONTAINDIR")

  for app in $APPS ; do
    local DESC
    DESC=$(cat "$CONTAINDIR/$app/.description")
    OPTIONS=("${OPTIONS[@]}" "$app" "$DESC" ON)
  done

  local SELECTION

  SELECTION=$(whiptail --title "media-docker Configuration" --checklist \
    "Enable or disable applications" 0 0 0 \
    "${OPTIONS[@]}" 3>&1 1>&2 2>&3 || echo "Exit")

  case $SELECTION in
    "Exit")
      run_sh "$MENUDIR" "menu_main"
    ;;
    *)
      echo $SELECTION
      run_sh "$MENUDIR" "menu_main"
    ;;
  esac
}