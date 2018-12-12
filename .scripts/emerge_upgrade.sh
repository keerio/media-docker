#!/usr/bin/env bash
set -euo pipefail

emerge_upgrade() {
  log 6 "Upgrading packages from emerge."
  sudo emerge -u world > /dev/null 2>&1 \
    || log 3 "Error occurred while updating packages from emerge."
}
