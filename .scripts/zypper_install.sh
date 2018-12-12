#!/usr/bin/env bash
set -euo pipefail

zypper_install() {
  run_sh "$SCRIPTDIR" "zypper_update"
  shift

  log 7 "Starting zypper install process."
  sudo zypper -n install "$@" \
    > /dev/null 2>&1 || log 3 "Error installing packages: $*."

  log 6 "Successfully installed requested package(s): $*."
  return 0
}
