#!/usr/bin/env bash
# shellcheck disable=SC2086
# shellcheck disable=SC2089
# shellcheck disable=SC2090
set -euo pipefail

toml_write() {
  local FILE
  local KEY
  local VALUE

  FILE=${1:-"new.toml"}
  KEY=${2:-}
  VALUE=${3:-}

  KEYGROUP=$(echo "$KEY" | awk 'BEGIN{FS=OFS="."}{NF--; print}')
  NAME=$(echo "$KEY" | awk -F\. '{print $NF}')

  if ! [[ "$VALUE" =~ \[.*\] ]] && [[ -n "$VALUE" ]] \
    && [[ "$VALUE" != "true" ]] && [[ "$VALUE" != "false" ]] ; then
    VALUE="\"$VALUE\""
  fi

  touch "$FILE"

  if [[ -n "$VALUE" ]] ; then
    if [[ -z "$KEYGROUP" ]] ; then
      echo -e "$NAME = $VALUE" >> "$FILE"
    else
      if grep -q "$KEYGROUP" "$FILE"; then

        sudo sed -i '/\['"$KEYGROUP"'\]/a'$NAME' = '$VALUE'' "$FILE"
      else
        echo -e "[$KEYGROUP]\n$NAME = $VALUE" >> "$FILE"
      fi
    fi
  else
    if [[ -z "$KEYGROUP" ]] ; then
      echo -e "[$NAME]" >> "$FILE"
    else
      echo -e "[$KEYGROUP.$NAME]" >> "$FILE"
    fi
  fi
}