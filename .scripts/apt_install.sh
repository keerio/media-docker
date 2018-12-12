#!/usr/bin/env bash
set -euo pipefail

apt_install() {
  run_sh "$SCRIPTDIR" "apt_update"
  shift

  log 7 "Starting apt install process."
  sudo apt-get -y install "$@" \
    > /dev/null 2>&1 || log 3 "Error installing packages: $*."

  log 6 "Successfully installed requested package(s): $*."
  return 0
}
