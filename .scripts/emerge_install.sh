#!/usr/bin/env bash
set -euo pipefail

emerge_install() {
  run_sh "$SCRIPTDIR" "emerge_update"
  shift

  log 7 "Starting emerge install process."
  sudo emerge "$@" \
    > /dev/null 2>&1 || log 3 "Error installing packages: $*."

  log 6 "Successfully installed requested package(s): $*."
  return 0
}
