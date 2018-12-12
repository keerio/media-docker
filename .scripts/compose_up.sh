#!/usr/bin/env bash
# shellcheck disable=SC2143
set -euo pipefail

compose_up() {
  if [[ ! $(sudo docker network ls \
    | grep proxied) ]] ; then
      sudo docker network create proxied \
        > /dev/null 2>&1 || err "Error occured creating Docker network."
  fi
  sudo docker-compose up --force-recreate -d \
    | tee -a "$LOGFILE" || err "Error occured bringing up containers."
}
