#!/usr/bin/env bash
set -euo pipefail

timezone_get() {
  local TZ
  if [ -f /etc/timezone ]; then
    TZ=$(cat /etc/timezone)
  elif [ -h /etc/localtime ]; then
    TZ=$(readlink /etc/localtime | sed "s/\/usr\/share\/zoneinfo\///")
  else
    checksum="$(md5sum /etc/localtime | cut -d' ' -f1)"
    TZ="$( find /usr/share/zoneinfo -type f -exec sh -c 'md5sum "$1" '\
      '| grep "^$2" | sed "s/.*\/usr\/share\/zoneinfo\///" '\
      '| head -n 1' -- {} "$checksum" \;)"
  fi

  echo "$TZ"
}
