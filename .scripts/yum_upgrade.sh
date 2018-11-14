#!/usr/bin/env bash
set -euo pipefail

yum_upgrade() {
  info "Upgrading packages from yum."
  sudo yum -y upgrade > /dev/null 2>&1 \
    || err "Error occurred while updating packages from yum."
}
