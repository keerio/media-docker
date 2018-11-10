#!/usr/bin/env bash
set -euo pipefail

app_is_active() {
  local APP
  local -a APPS
  local -A MAPAPPS

  APP=${1:-}

  APPS=$(run_sh "$SCRIPTDIR" "apps_active_list" "$BASEDIR/.apps")
  for app in $APPS ; do
    MAPAPPS["$app"]=1
  done

  if [[ ${MAPAPPS["$APP"]+_} ]] 
  then 
    return 0
  else
    return 1
  fi
}