#!/usr/bin/env bash
set -euo pipefail

self_config_store() {
  if [[ ! -f "${BASEDIR}/.mdc" ]]
  then
    echo "# media-docker location config" >> "${BASEDIR}/.mdc"
    
    run_sh "$SCRIPTDIR" "env_set" \
      "SOURCE_NAME" "${SOURCENAME}" "${BASEDIR}/.mdc"
    run_sh "$SCRIPTDIR" "env_set" \
      "BASE_DIR" "${BASEDIR}" "${BASEDIR}/.mdc"
    run_sh "$SCRIPTDIR" "env_set" \
      "SCRIPT_DIR" "${SCRIPTDIR}" "${BASEDIR}/.mdc"
    run_sh "$SCRIPTDIR" "env_set" \
      "TEST_DIR" "${TESTDIR}" "${BASEDIR}/.mdc"
    run_sh "$SCRIPTDIR" "env_set" \
      "MENU_DIR" "${MENUDIR}" "${BASEDIR}/.mdc"
    run_sh "$SCRIPTDIR" "env_set" \
      "CONFIG_DIR" "${CONFIGDIR}" "${BASEDIR}/.mdc"
    run_sh "$SCRIPTDIR" "env_set" \
      "CONTAIN_DIR" "${CONTAINDIR}" "${BASEDIR}/.mdc"
    run_sh "$SCRIPTDIR" "env_set" \
      "BACKUP_DIR" "${BACKUPDIR}" "${BASEDIR}/.mdc"
  fi
}