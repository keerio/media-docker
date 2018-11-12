#!/usr/bin/env bash
set -euo pipefail

root_check() {
  if [[ ${EUID} -ne 0 ]]; then
    err "Must be root to perform this operation."
  fi
}
