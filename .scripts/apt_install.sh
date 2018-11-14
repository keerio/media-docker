#!/usr/bin/env bash
set -euo pipefail

apt_install() {
  run_sh "$SCRIPTDIR" "apt_update"
  shift
  sudo apt-get install -y "$@" \
    > /dev/null 2>&1 || err "Error installing packages: $*."

  success "Successfully installed requested package(s): $*."
  return 0
}
