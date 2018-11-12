#!/usr/bin/env bash
set -euo pipefail

self_config_delete() {
  if [[ -f "${BASEDIR}/.mdc" ]] ; then
    sudo rm "${BASEDIR}/.mdc"
  fi
}
