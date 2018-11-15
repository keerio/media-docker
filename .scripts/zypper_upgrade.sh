#!/usr/bin/env bash
set -euo pipefail

zypper_upgrade() {
  info "Upgrading packages from zypper."
  sudo zypper -n dup > /dev/null 2>&1 \
    || err "Error occurred while updating packages from zypper."
}
