#!/usr/bin/env bash
set -euo pipefail

apt_upgrade() {
  info "Upgrading packages from apt."
  sudo apt-get -y dist-upgrade > /dev/null 2>&1 \
    || err "Error occurred while updating packages from apt."
}
