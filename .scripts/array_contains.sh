#!/usr/bin/env bash
set -euo pipefail

array_contains () {
  local VAL
  local ARR
  local -A MAP

  VAL=${1:-}
  ARR=${2:-}

  for item in $ARR ; do
    MAP["$item"]=1
  done

  if [[ ${MAP["$VAL"]+_} ]] ; then
    echo "0"
  else
    echo "1"
  fi
}
