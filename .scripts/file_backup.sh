#!/usr/bin/env bash
set -euo pipefail

file_backup() {
  local FULLFILE
  local FILENAME
  local NOW

  NOW=$(date +"%Y-%m-%d.%s")
  FULLFILE=${1:-}
  FILENAME=$(basename "$FULLFILE")

  sudo mkdir -p "$BACKUPDIR" > /dev/null 2>&1 \
    || err "Error when creating backup directory."
  sudo mv "$FULLFILE" "${BACKUPDIR}/${FILENAME}.${NOW}" \
    > /dev/null 2>&1 \
    || err "Error when backing up ${FILENAME}."
}
