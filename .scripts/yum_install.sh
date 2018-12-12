#!/usr/bin/env bash
set -euo pipefail

yum_install() {
  run_sh "$SCRIPTDIR" "yum_update"
  shift

  log 7 "Starting yum install process."
  sudo yum -y install "$@" \
    > /dev/null 2>&1 || log 3 "Error installing packages: $*."

  log 6 "Successfully installed requested package(s): $*."
  return 0
}
