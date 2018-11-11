#!/usr/bin/env bash
set -euo pipefail

array_contains () {
  local e match="$1"
  shift
  for e; do [[ "$e" = "$match" ]] && return 0; done
  return 1
}