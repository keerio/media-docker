#!/usr/bin/env bash
set -euo pipefail

timezone_list() {
  local -a TIMEZONES

  log 7 "Grabbing list of timezones from zone.tab."
  TIMEZONES=("$(grep -v "#" /usr/share/zoneinfo/zone.tab \
    | cut -f 3 | sort -k3)")

  echo "${TIMEZONES[@]}"
}
