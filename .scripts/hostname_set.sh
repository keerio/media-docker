#!/usr/bin/env bash
set -euo pipefail

hostname_set() {
  local CURRHOST
  local NEWHOST

  CURRHOST=$(cat /etc/hostname)
  NEWHOST=${1:-CURRHOST}

  sudo sed -i "s/$CURRHOST/$NEWHOST/g" /etc/hosts
  sudo sed -i "s/$CURRHOST/$NEWHOST/g" /etc/hostname

  echo "$NEWHOST"
}
