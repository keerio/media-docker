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

  log 7 "Checking if we should quote the value."
  if ! [[ "$VALUE" =~ \[.*\] ]] && [[ -n "$VALUE" ]] \
    && [[ "$VALUE" != "true" ]] && [[ "$VALUE" != "false" ]] ; then
    VALUE="\"$VALUE\""
  fi

  log 7 "Ensuring ${FILE} exists."
  touch "$FILE"

  log 7 "Writing to TOML."
  if [[ -n "$VALUE" ]] ; then
    log 7 "Value exists, write to file appropriately."
    if [[ -z "$KEYGROUP" ]] ; then
      log 7 "No keygroup, write as key = value."
      echo -e "$NAME = $VALUE" >> "$FILE"
    else
      if grep -q "$KEYGROUP" "$FILE"; then
        log 7 "Keygroup already in file, write near it."
        sudo sed -i '/\['"$KEYGROUP"'\]/a'$NAME' = '$VALUE'' "$FILE"
      else
        log 7 "Keygroup not in file, write new keygroup."
        echo -e "[$KEYGROUP]\n$NAME = $VALUE" >> "$FILE"
      fi
    fi
  else
    log 7 "Value does not exist, write to file as bare keygroup."
    if [[ -z "$KEYGROUP" ]] ; then
      log 7 "Keygroup already in file, write near it."
      echo -e "[$NAME]" >> "$FILE"
    else
      log 7 "Keygroup not in file, write new keygroup."
      echo -e "[$KEYGROUP.$NAME]" >> "$FILE"
    fi
  fi
}