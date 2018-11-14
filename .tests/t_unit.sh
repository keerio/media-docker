#!/usr/bin/env bash

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

# extract shared values from config
val_get() {
  local KEY=${1:-}
  local FILE="${CURDIR}/../.mdc"
  local VAL=

  VAL=$(grep "$KEY" "$FILE" | xargs)
  IFS="=" read -ra VAL <<< "$VAL"
  if [[ ${VAL[1]+"${VAL[1]}"} ]]
  then
    echo "${VAL[1]}" | tr -d "\r"
  fi
}

# test app_is_active()
test_app_is_active_true() {
  assertEquals 0 $(app_is_active "traefik" "${TESTDIR}/.apps")
}
test_app_is_active_false() {
  assertEquals 1 $(app_is_active "heimdall" "${TESTDIR}/.apps")
}

# test array_contains
test_array_contains_true() {
  assertEquals 0 $(array_contains "traefik" "${TEST_ARRAY[@]}")
}
test_array_contains_false() {
  assertEquals 1 $(array_contains "plex" "${TEST_ARRAY[@]}")
}

# test file_append
test_file_append() {
  file_append "${TESTDIR}/.apps-test" "${TESTDIR}/.apps"
  result=$(cat "${TESTDIR}/.apps-test")
  actual=$(cat "${TESTDIR}/.apps")
  assertEquals "$actual" "$result"
}

oneTimeSetUp() {
  set +u

  # GLOBALS
  readonly CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
  readonly SOURCENAME="$(val_get "SOURCE_NAME")"
  readonly BASEDIR="$(val_get "BASE_DIR")"
  readonly SCRIPTDIR="$(val_get "SCRIPT_DIR")"
  readonly TESTDIR="$(val_get "TEST_DIR")"
  readonly MENUDIR="$(val_get "MENU_DIR")"
  readonly CONFIGDIR="$(val_get "CONFIG_DIR")"
  readonly CONTAINDIR="$(val_get "CONTAIN_DIR")"
  readonly BACKUPDIR="$(val_get "BACKUP_DIR")"

  . "${SCRIPTDIR}/app_is_active.sh"
  . "${SCRIPTDIR}/array_contains.sh"
  . "${SCRIPTDIR}/file_append.sh"

  TEST_ARRAY=("bazarr" "traefik" "watchtower")
}

. .tests/shunit2-2.1.6/src/shunit2
