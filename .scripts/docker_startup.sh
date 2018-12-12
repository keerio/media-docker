#!/usr/bin/env bash
set -euo pipefail
docker_startup() {
  local INITSYS

  log 7 "Attempting to set Docker to startup with init."
  INITSYS=$(run_sh "$SCRIPTDIR" "init_detect")
  case "$INITSYS" in
    systemd)
      sudo systemctl enable docker
      sudo systemctl start docker
    ;;
    sysv-init)
      sudo /etc/init.d/docker start
    ;;
    upstart)
    ;;
    launchd)
    ;;
  esac
}
