#!/usr/bin/env bash
set -euo pipefail

file_append() {
  local OUTFILE
  local INFILE

  OUTFILE=${1:-}
  INFILE=${2:-}

  cat "$OUTFILE" | sudo tee -a "$INFILE" > /dev/null
}