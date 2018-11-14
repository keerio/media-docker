#!/usr/bin/env bash
set -euo pipefail

dnf_upgrade() {
  info "Upgrading packages from dnf."
  sudo dnf -y upgrade > /dev/null 2>&1 \
    || err "Error occurred while updating packages from dnf."
}
