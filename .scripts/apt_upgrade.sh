#!/usr/bin/env bash
set -euo pipefail

apt_upgrade() {
  log 6 "Upgrading packages from apt."
  sudo apt-get -y dist-upgrade > /dev/null 2>&1 \
    || log 3 "Error occurred while updating packages from apt."
}
