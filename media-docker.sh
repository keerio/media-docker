#!/usr/bin/env bash
#
# Perform initial setup and configuration of Docker environment for 
# full media server goodness.
# shellcheck disable=SC2143

#/ Usage: sudo media-docker [OPTIONS]
#/ Description: media-docker installation and configuration tool.
#/ 
#/ To run the GUI installer / configurator, run media-docker without options.
#/
#/ Options:
#/
#/   -p, --prereq <noremove/test>: Install pre-requisites.
#/   -a, --apps: View or edit your .apps file
#/   -e, --env: View or edit your .env file
#/   -c, --compose <up/down/restart/pull/create>: Rebuild your compose environment from selected options
#/   -u, --update: Update media-docker
#/   -P, --prune: Prune the Docker system
#/   -t, --test: Run tests
#/   -v, --verbose: Include detailed logging to terminal.
#/   -x, --debug: Include debug information in terminal.
#/   -l, --logLevel <n>: Sets log level to defined number `n`. Must be a number.
#/   -h, --help: Display this help message
#/
usage() { grep '^#/' "${SOURCENAME}" | cut -c4- ; exit 0 ; }

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

# script runner
run_sh() {
  local DIR="${1:-}"
  local FILE="${2:-}"
  shift; shift

  if [[ -f "${DIR}/${FILE}.sh" ]] ; then
    source "${DIR}/${FILE}.sh"
    ${FILE} "$@";
  else
    log 3 "${DIR}/${FILE}.sh not found."
  fi
}

# script info.
_VERBOSE=3
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

log() {
  # colors
  local RED='\033[0;31m'
  local YELLOW='\033[1;33m'
  local BLUE='\033[34m'
  local NOCOL='\033[0m'

  local -A LOGLVLS=([0]="EMERG" [1]="ALERT" [2]="CRIT" [3]="ERR" [4]="WARN" \
    [5]="NOTICE" [6]="INFO" [7]="DEBUG")

  local LVL=${1}
  local COL
  local MSG
  shift

  if [[ "${LVL}" -le 3 ]] ; then
    COL="${RED}"
  elif [[ "${LVL}" -le 5 ]] ; then
    COL="${YELLOW}"
  elif [[ "${LVL}" -le 7 ]] ; then
    COL="${BLUE}"
  else
    COL="${NOCOL}"
  fi

  MSG="[${LOGLVLS[$LVL]}] [$(date +'%Y-%m-%dT%H:%M:%S%z')] $*"

  if [[ ${_VERBOSE} -ge ${LVL} ]] ; then
    echo -e "${COL}${MSG}${NOCOL}" >&2
  fi

  touch "${LOGFILE}"
  echo "${MSG}" >> "${LOGFILE}"

  if [[ "${LVL}" -le 3 ]] ; then
    exit 1
  fi
}

finish() {
  local EXIT_CODE="$?"
  log 7 "Exit code: ${EXIT_CODE}"
  log 6 "Cleaning up after ourselves."
  if [[ ${EXIT_CODE} -eq 222 ]] ; then
    log 6 "Installer process, no clean up required."
  else
    if [[ $(service --status-all | grep -Fq 'docker') ]] ; then
      log 6 "Restarting Docker service."
      sudo service docker restart || true
    fi

    log 6 "Ensuring that we are executable."
    run_sh "$SCRIPTDIR" "self_chmod" || true

    log 6 "Ensuring that our symlink is set."
    run_sh "$SCRIPTDIR" "self_symlink" || true

    log 6 "Removing media-docker config temp file."
    run_sh "$SCRIPTDIR" "self_config_delete" || true

    log 6 "Ensuring testing files are gone."
    sudo rm -f "${TESTDIR}/.apps-test" || true
    sudo rm -f "${TESTDIR}/docker-compose-test.yml" || true
    sudo rm -f "${TESTDIR}/docker-compose.yml" || true
  fi
}
trap finish EXIT

# main
main() {
  local -a PREREQ_CHECKS
  mkdir -p "$(dirname "${LOGFILE}")"

  log 7 "Checking if media-docker is installed."
  if [[ ! -d ${BASEDIR}/.git ]] ; then
    _VERBOSE=6
    log 5 "Downloading media-docker to ${BASEDIR}/media-docker."
    git clone "https://github.com/joskore/media-docker" \
      "${BASEDIR}/media-docker" || log 3 "Error occurred when cloning repo."

    log 6 "Cleaning up current file."
    if [[ -f "$0" ]] ; then
      sudo rm "$0"
    fi

    log 6 "Running newly downloaded media-docker."
    (cd "${BASEDIR}/media-docker/" && \
      sudo bash "${BASEDIR}/media-docker/media-docker.sh")
    exit 222
  fi

  log 6 "Checking media-docker requirements."

  set +u
  log 6 "Checking that architecture is supported"
  PREREQ_CHECKS=("${PREREQ_CHECKS[@]}" \
    "$(run_sh "$SCRIPTDIR" "arch_is_supported" "$ARCH")")

  log 6 "Checking that we are root."
  PREREQ_CHECKS=("${PREREQ_CHECKS[@]}" \
    "$(run_sh "$SCRIPTDIR" "root_check")")

  log 6 "Ensuring .ENV is created and up to date."
  PREREQ_CHECKS=("${PREREQ_CHECKS[@]}" \
    "$(run_sh "$SCRIPTDIR" "env_create" "$CONFIGDIR" "$BASEDIR")")

  log 6 "Ensuring .APPS is created and up to date."
  PREREQ_CHECKS=("${PREREQ_CHECKS[@]}" \
    "$(run_sh "$SCRIPTDIR" "apps_create" "$CONFIGDIR" "$BASEDIR")")

  if [[ $(run_sh "${SCRIPTDIR}" "array_contains" \
    "1" "${PREREQ_CHECKS[@]}") -eq 0 ]] ; then
    log 3 "Prerequisite checking failed, exiting."
  fi

  set -u

  log 6 "Stashing self config in .MDC"
  run_sh "$SCRIPTDIR" "self_config_store"

  log 6 "Detected CLI arguments included, passing to CLI menu."
  run_sh "$MENUDIR" "cli" "${ARGS[@]:-}"

  log 6 "Starting Whiptail GUI menu."
  run_sh "$MENUDIR" "menu_main" || true
}
main
