#!/usr/bin/env bash
# shellcheck disable=SC2068
set -euo pipefail

arch_is_supported(){
  local -a SUPPORTED_ARCH
  local DETECTED_ARCH

  SUPPORTED_ARCH=("x86_64" "aarch64" "armv71")
  DETECTED_ARCH=${1:-}

  for sup in ${SUPPORTED_ARCH[@]} ; do
    if [[ "$sup" == "$DETECTED_ARCH" ]] ; then
      info "Detected architecture as: ${DETECTED_ARCH}."
      return
    fi
  done

  err "Unsupported architecture detected: ${DETECTED_ARCH}."
}