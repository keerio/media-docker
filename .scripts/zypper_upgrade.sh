#!/usr/bin/env bash
set -euo pipefail

zypper_upgrade() {
  log 6 "Upgrading packages from zypper."
  sudo zypper -n dup > /dev/null 2>&1 \
    || log 3 "Error occurred while updating packages from zypper."
}
