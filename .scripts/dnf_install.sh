#!/usr/bin/env bash
set -euo pipefail

dnf_install() {
  run_sh "$SCRIPTDIR" "dnf_update"
  shift
  sudo dnf -y install "$@" \
    > /dev/null 2>&1 || err "Error installing packages: $*."

  success "Successfully installed requested package(s): $*."
  return 0
}
