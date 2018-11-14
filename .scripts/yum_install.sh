#!/usr/bin/env bash
set -euo pipefail

yum_install() {
  run_sh "$SCRIPTDIR" "yum_update"
  shift
  sudo yum install -y "$@" \
    > /dev/null 2>&1 || err "Error installing packages: $*."

  success "Successfully installed requested package(s): $*."
  return 0
}
