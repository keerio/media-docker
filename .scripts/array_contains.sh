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

  log 7 "Checking if array contains: ${VAL}."
  if [[ ${MAP["$VAL"]+_} ]] ; then
    log 7 "Array contains ${VAL}."
    echo "0"
    return 0
  else
    log 7 "Array does not contain ${VAL}."
    echo "1"
    return 1
  fi
}
