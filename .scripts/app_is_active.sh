#!/usr/bin/env bash
set -euo pipefail

app_is_active() {
  local APP
  local FILE
  local -a APPS
  local -A MAPAPPS

  APP=${1:-}
  FILE=${2:-"$BASEDIR/.apps"}

  APPS=$(run_sh "$SCRIPTDIR" "apps_active_list" "$FILE")
  for app in $APPS ; do
    MAPAPPS["$app"]=1
  done

  if [[ ${MAPAPPS["$APP"]+_} ]] ; then
    echo "0"
  else
    echo "1"
  fi
}
