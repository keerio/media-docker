#!/usr/bin/env bash
set -euo pipefail

array_contains () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && echo "match" && return 0; done
  echo "nomatch" && return 1
}