#!/usr/bin/env bash
set -euo pipefail

yum_upgrade() {
  log 6 "Upgrading packages from yum."
  sudo yum -y upgrade > /dev/null 2>&1 \
    || log 3 "Error occurred while updating packages from yum."
}
