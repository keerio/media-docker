#!/usr/bin/env bash
set -euo pipefail

cli() {
  local PARSED_ARGS=
  local DELIM=

  for arg in "$@" ; do
    shift
    case "$arg" in
      --prereq)
        PARSED_ARGS="${PARSED_ARGS:-}-p "
      ;;
      --apps)
        PARSED_ARGS="${PARSED_ARGS:-}-a "
      ;;
      --env)
        PARSED_ARGS="${PARSED_ARGS:-}-e "
      ;;
      --compose)
        PARSED_ARGS="${PARSED_ARGS:-}-c "
      ;;
      --update)
        PARSED_ARGS="${PARSED_ARGS:-}-u "
      ;;
      --prune)
        PARSED_ARGS="${PARSED_ARGS:-}-P "
      ;;
      --test)
        PARSED_ARGS="${PARSED_ARGS:-}-t "
      ;;
      --help)
        PARSED_ARGS="${PARSED_ARGS:-}-h "
      ;;
      *) 
        [[ "${arg:0:1}" == "-" ]] || DELIM="\""
        PARSED_ARGS="${PARSED_ARGS:-}${DELIM}${arg}${DELIM} " 
      ;;
    esac
  done

  eval set -- "${PARSED_ARGS:-}"

  while getopts ":paec:uPh" SELECTED ; do
    case $SELECTED in
      p)
        run_sh "$SCRIPTDIR" "apt_prereqs_install"
        exit
      ;;
      a)
        run_sh "$SCRIPTDIR" "editor_open" "${BASEDIR}/.apps"
        exit
      ;;
      e)
        run_sh "$SCRIPTDIR" "editor_open" "${BASEDIR}/.env"
        exit
      ;;
      c)
        case ${OPTARG} in
          up)
            run_sh "$SCRIPTDIR" "compose_create"
            run_sh "$SCRIPTDIR" "compose_up"
          ;;
          pull)
            run_sh "$SCRIPTDIR" "compose_create"
            run_sh "$SCRIPTDIR" "compose_pull"
          ;;
          restart)
            run_sh "$SCRIPTDIR" "compose_create"
            run_sh "$SCRIPTDIR" "compose_restart"
          ;;
          down)
            run_sh "$SCRIPTDIR" "compose_down"
          ;;
          create)
            run_sh "$SCRIPTDIR" "compose_create"
          ;;
          *)
            usage
          ;;
        esac
        exit
      ;;
      u)
        run_sh "$SCRIPTDIR" "self_update"
        exit
      ;;
      P)
        run_sh "$SCRIPTDIR" "docker_prune"
        exit
      ;;
      t)
        run_sh "$TESTDIR" "${OPTARG}"
        exit
      ;;
      h)
        usage
        exit
      ;;
      :)
        case ${OPTARG} in
          c)
            run_sh "$SCRIPTDIR" "compose_create"
            run_sh "$SCRIPTDIR" "compose_up"
            exit
          ;;
          *)
            err "${OPTARG} requires an argument."
            exit
          ;;
        esac
      ;;
      *)
        usage
        exit
      ;;
    esac
  done
  return 0
}