#!/bin/bash

# Requirements:
# - Windows Commandline
# - Cygwin + curl (Intune-Client)
#   - Alternative: https://curl.se/windows/
#
# (c) 2025 Oliver Glowa (glo03) / Arvato Systems GmbH
#
# Ensure that $MY_SPACES is set in ~/.restapi/my.conf

source "$(dirname "$0")"/env-restapi.sh

if [ "${SPACEKEY}" = "" ]; then
  __availSpaces=(${MY_SPACES} quit)
  PS3='Please enter your choice: '
  printf "\nPlease select a space:\n"
  select __answer in "${__availSpaces[@]}"
  do
      case $__answer in
          "quit")
              break
              ;;
          *)  SPACEKEY="${__answer}"
              break
            ;;
        esac
  done
  printf "\nYou have chosen space '%s'.\n" "${SPACEKEY}"
  if [ "${SPACEKEY}" = "" ]; then
    exit 20
  fi
fi
