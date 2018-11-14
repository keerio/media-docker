#!/usr/bin/env bash
set -euo pipefail

emerge_install() {
  run_sh "$SCRIPTDIR" "emerge_update"
  shift
  sudo emerge "$@" \
    > /dev/null 2>&1 || err "Error installing packages: $*."

  success "Successfully installed requested package(s): $*."
  return 0
}
