#!/usr/bin/env bash
set -euo pipefail

file_backup() {
  local FULLFILE
  local FILENAME
  local NOW

  NOW=$(date +"%Y-%m-%d.%s")
  FULLFILE=${1:-}
  FILENAME=$(basename "$FULLFILE")

  sudo mv "$FULLFILE" "${BACKUPDIR}/${FILENAME}.${NOW}"
}
