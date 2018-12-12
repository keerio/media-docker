#!/usr/bin/env bash
set -euo pipefail

dnf_upgrade() {
  log 6 "Upgrading packages from dnf."
  sudo dnf -y upgrade > /dev/null 2>&1 \
    || log 3 "Error occurred while updating packages from dnf."
}
