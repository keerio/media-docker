#!/usr/bin/env bash
set -euo pipefail

compose_up() {
  sudo docker network create proxied \
    > /dev/null 2>&1 || err "Error occured creating Docker network."
  sudo docker-compose up --force-recreate -d \
    > /dev/null 2>&1 || err "Error occured bringing up containers."
}