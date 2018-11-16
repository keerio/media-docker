#!/usr/bin/env bash
#
# Perform initial setup and configuration of Docker environment for 
# full media server goodness.
# shellcheck disable=SC2143

set -euo pipefail

## GLOBALS
get_source() {
  local SOURCE
  local DIR

  SOURCE="${BASH_SOURCE[0]}"

  while [[ -h "${SOURCE}" ]]; do
    DIR="$( cd -P "$( dirname "${SOURCE}" )" > /dev/null && pwd )"
    SOURCE="$(readlink "${SOURCE}")"
    [[ ${SOURCE} != /* ]] && SOURCE="${DIR}/${SOURCE}"
  done

  echo "${SOURCE}"
}

# script info
readonly ARGS=("$@")
readonly ARCH="$(uname -m)"
readonly SOURCENAME="$(get_source)"
readonly CURRENT_UID=$UID
readonly BASEDIR="$( cd -P "$( dirname "$SOURCENAME" )" >/dev/null && pwd )"
readonly SCRIPTDIR="$BASEDIR/.scripts/"
readonly TESTDIR="$BASEDIR/.tests/"
readonly MENUDIR="$BASEDIR/.menus/"
readonly CONFIGDIR="$BASEDIR/.config/"
readonly CONTAINDIR="$BASEDIR/.containers/"
readonly BACKUPDIR="$BASEDIR/.backups/"
readonly LOGFILE="$BASEDIR/.logs/media-docker-$(date +%s).log"

# colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly BLUE='\e[34m'
readonly NOCOL='\033[0m'

# logging functions
info() {
  echo -e "${BLUE}[INFO] [$(date +'%Y-%m-%dT%H:%M:%S%z')]  $*${NOCOL}" \
    | tee -a "$LOGFILE" >&2 ;
}
err() {
  echo -e "${RED}[ERR]  [$(date +'%Y-%m-%dT%H:%M:%S%z')]  $*${NOCOL}" \
    | tee -a "$LOGFILE" >&2 ;
  exit 1
}
success() {
  echo -e "${GREEN}[SUCCESS]  [$(date +'%Y-%m-%dT%H:%M:%S%z')]  $*${NOCOL}" \
    | tee -a "$LOGFILE" >&2 ;
}

# script runner
run_sh() {
  local DIR="${1:-}"
  local FILE="${2:-}"
  shift; shift
  if [[ -f "${DIR}/${FILE}.sh" ]] ; then
    source "${DIR}/${FILE}.sh"
    ${FILE} "$@";
  else
    err "${DIR}/${FILE}.sh not found."
  fi
}

#/ Usage: sudo media-docker [OPTIONS]
#/ Description: media-docker installation and configuration tool.
#/ 
#/ To run the GUI installer / configurator, run media-docker without options.
#/
#/ Options:
#/
#/   -p, --prereq: Install pre-requisites.
#/   -a, --apps: View or edit your .apps file
#/   -e, --env: View or edit your .env file
#/   -c, --compose <up/down/restart/pull/create>: Rebuild your compose environment from selected options
#/   -u, --update: Update media-docker
#/   -P, --prune: Prune the Docker system
#/   -t, --test: Run tests
#/   -h, --help: Display this help message
#/
usage() { grep '^#/' "${SOURCENAME}" | cut -c4- ; exit 0 ; }

finish() {
  if [[ $(service --status-all | grep -Fq 'docker') ]] ; then
    sudo service docker restart || true
  fi
  run_sh "$SCRIPTDIR" "self_symlink" || true
  run_sh "$SCRIPTDIR" "self_config_delete" || true
  sudo rm -f "${TESTDIR}/.apps-test" || true
  sudo rm -f "${TESTDIR}/docker-compose-test.yml" || true
}
trap finish EXIT

# main
main() {
  # ensure log dir exists
  mkdir -p "$(dirname ${LOGFILE})"

  # prereqs for processes
  run_sh "$SCRIPTDIR" "arch_is_supported" "$ARCH"
  run_sh "$SCRIPTDIR" "root_check"
  run_sh "$SCRIPTDIR" "env_create" "$CONFIGDIR" "$BASEDIR"
  run_sh "$SCRIPTDIR" "apps_create" "$CONFIGDIR" "$BASEDIR"
  run_sh "$SCRIPTDIR" "self_config_store"

  # run cli if options are included
  run_sh "$MENUDIR" "cli" "${ARGS[@]:-}"

  # start menu
  run_sh "$MENUDIR" "menu_main"
}
main
