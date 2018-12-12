#!/usr/bin/env bash
set -euo pipefail

file_backup() {
  local FULLFILE
  local FILENAME
  local NOW

  NOW=$(date +"%Y-%m-%d.%s")
  FULLFILE=${1:-}
  FILENAME=$(basename "$FULLFILE")

  log 7 "Ensuring backup directory exists."
  sudo mkdir -p "$BACKUPDIR" > /dev/null 2>&1 \
    || log 3 "Error when creating backup directory."
  log 6 "Backing up ${FILENAME}."
  sudo mv "$FULLFILE" "${BACKUPDIR}/${FILENAME}.${NOW}" \
    > /dev/null 2>&1 \
    || log 3 "Error occurred while backing up ${FILENAME}."
}
