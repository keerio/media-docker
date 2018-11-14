#!/usr/bin/env bash
set -euo pipefail

pacman_install() {
  run_sh "$SCRIPTDIR" "pacman_update"
  shift
  sudo pacman -S --noconfirm "$@" \
    > /dev/null 2>&1 || err "Error installing packages: $*."

  success "Successfully installed requested package(s): $*."
  return 0
}
