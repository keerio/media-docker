#!/usr/bin/env bash
set -euo pipefail

array_contains () {
  local VAL
  local -A MAP
  MAP[0]=1

  VAL=${1:-}
  shift

  for item in "$@" ; do
    if [[ ! -z $item ]] ; then
      MAP[$item]=1
    fi
  done

  if [[ ${MAP["$VAL"]+_} ]] ; then
    echo "0"
    return 0
  else
    echo "1"
    return 1
  fi
}
