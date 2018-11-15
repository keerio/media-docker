#!/usr/bin/env bash
set -euo pipefail

zypper_install() {
  run_sh "$SCRIPTDIR" "zypper_update"
  shift
  sudo zypper -n install "$@" \
    > /dev/null 2>&1 || err "Error installing packages: $*."

  success "Successfully installed requested package(s): $*."
  return 0
}
