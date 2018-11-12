#!/usr/bin/env bash
set -euo pipefail

timezone_list() {
  local -a TIMEZONES

  TIMEZONES=("$(grep -v "#" /usr/share/zoneinfo/zone.tab \
    | cut -f 3 | sort -k3)")

  echo "${TIMEZONES[@]}"
}
