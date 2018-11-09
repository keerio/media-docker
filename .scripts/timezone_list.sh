#!/usr/bin/env bash
set -euo pipefail

timezone_list() {
  local -a TIMEZONES
  
  TIMEZONES=("$(cat /usr/share/zoneinfo/zone.tab | grep -v "#" | cut -f 3 | sort -k3)")

  echo "${TIMEZONES[@]}"
}