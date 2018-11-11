#!/usr/bin/env bash
#
# Perform initial setup and configuration of Docker environment for 
# full media server goodness.

set -euo pipefail

## GLOBALS
get_source() {
  local SOURCE="${BASH_SOURCE[0]}"
  local BASE_DIR

  while [ -h "$SOURCE" ]; do
    BASE_DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$BASE_DIR/$SOURCE"
  done
  echo "$SOURCE"
}

# script info
readonly SOURCE="$(get_source)"
readonly BASEDIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null && pwd )"
readonly SCRIPTDIR="$BASEDIR/.scripts/"
readonly MENUDIR="$BASEDIR/.menus/"
readonly CONFIGDIR="$BASEDIR/.config/"
readonly CONTAINDIR="$BASEDIR/.containers/"
readonly BACKUPDIR="$BASEDIR/.backups/"
readonly CURRENT_UID=$UID

# colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly BLUE='\e[34m'
readonly NOCOL='\033[0m'

# logging functions
info() { echo -e "${BLUE}[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@${NOCOL}" ; }
err() { echo -e "${RED}[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@${NOCOL}" >&2 ; exit 1 ; }
success() { echo -e "${GREEN}[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@${NOCOL}" ; }

# script runner
run_sh() {
  local DIR="${1:-}"
  local FILE="${2:-}"
  shift; shift
  if [[ -f "${DIR}/${FILE}.sh" ]]
  then
    source "${DIR}/${FILE}.sh"
    ${FILE} "$@";
  else
    err "${DIR}/${FILE}.sh not found."
  fi
}

# main
main() {
  # prereqs for processes
  run_sh "$SCRIPTDIR" "root_check"
  run_sh "$SCRIPTDIR" "apt_check"
  run_sh "$SCRIPTDIR" "env_create" "$CONFIGDIR" "$BASEDIR"
  run_sh "$SCRIPTDIR" "apps_create" "$CONFIGDIR" "$BASEDIR"

  # start menu
  run_sh "$MENUDIR" "menu_main"
}

main