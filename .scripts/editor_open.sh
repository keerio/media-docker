#!/usr/bin/env bash
set -euo pipefail

editor_open() {
  local FILE
  FILE=${1:-}

  ${EDITOR:-nano} "$FILE"
}
