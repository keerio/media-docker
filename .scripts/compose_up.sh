#!/usr/bin/env bash
# shellcheck disable=SC2143
set -euo pipefail

compose_up() {
  log 6 "Checking if proxied Docker network exists."
  if [[ ! $(sudo docker network ls \
    | grep proxied) ]] ; then
      log 6 "Proxied Docker network does not exist, creating."
      sudo docker network create proxied \
        > /dev/null 2>&1 || log 3 "Error occured creating Docker network."
  fi

  log 6 "Attempting to bring up Docker stack."
  sudo docker-compose up --force-recreate -d \
    | tee -a "$LOGFILE" || log 3 "Error occured bringing up containers."
}
