#!/usr/bin/env bash
set -euo pipefail

apt_check() {
  command -v apt-get > /dev/null 2>&1 \
    || err "Setup requires apt but doesn't appear to be installed."
}
