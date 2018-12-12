#!/usr/bin/env bash
set -euo pipefail

file_append() {
  local OUTFILE
  local INFILE

  INFILE=${1:-}
  OUTFILE=${2:-}

  log 7 "Attempting to append ${OUTFILE} to ${INFILE}."
  sudo cat "$OUTFILE" | sudo tee -a "$INFILE" > /dev/null
}
