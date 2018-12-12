#!/usr/bin/env bash
set -euo pipefail

dnf_install() {
  run_sh "$SCRIPTDIR" "dnf_update"
  shift

  log 7 "Starting dnf install process."
  sudo dnf -y install "$@" \
    > /dev/null 2>&1 || log 3 "Error installing packages: $*."

  log 6 "Successfully installed requested package(s): $*."
  return 0
}
