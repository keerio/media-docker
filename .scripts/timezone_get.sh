#!/usr/bin/env bash
set -euo pipefail

timezone_get() {
  local TZ

  log 7 "Checking for current timezone."
  if [ -f /etc/timezone ]; then
    log 7 "Grabbing timezone from /etc/timezone."
    TZ=$(cat /etc/timezone)
  elif [ -h /etc/localtime ]; then
    log 7 "Grabbing timezone from /etc/localtime."
    TZ=$(readlink /etc/localtime | sed "s/\/usr\/share\/zoneinfo\///")
  else
    log 7 "Grabbing timezone from /usr/share/zoneinfo."
    checksum="$(md5sum /etc/localtime | cut -d' ' -f1)"
    TZ="$( find /usr/share/zoneinfo -type f -exec sh -c 'md5sum "$1" '\
      '| grep "^$2" | sed "s/.*\/usr\/share\/zoneinfo\///" '\
      '| head -n 1' -- {} "$checksum" \;)"
  fi

  echo "$TZ"
}
