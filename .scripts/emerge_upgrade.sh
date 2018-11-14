#!/usr/bin/env bash
set -euo pipefail

emerge_upgrade() {
  info "Upgrading packages from emerge."
  sudo emerge -u world > /dev/null 2>&1 \
    || err "Error occurred while updating packages from emerge."
}
