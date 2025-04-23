#!/bin/bash

# Requirements:
# - Windows Commandline
# - Cygwin + curl (Intune-Client)
#   - Alternative: https://curl.se/windows/
#
# (c) 2024 Oliver Glowa (glo03) / Arvato Systems GmbH
#
# Call:
# ./count-pages.sh [<SPACEKEY>|interactive menu]
#

source ./common/env-restapi.sh

if [ "$1" != "" ]; then
  SPACEKEY=$1
else
  source ./common/space-choose.sh
fi

getSpaceSize() {
  local __type=$1
  local __result=$2

  # Get the space size
  local __searchUrl="${CONF_SEARCH_URL}?cql=type+in+(${__type})+AND+space=${SPACEKEY}"
  printf "%s\n" "${__searchUrl}"

  # Get the number of pages
  local __curlResult
  __curlResult=$(curl -s -H "${CONF_AUTH}" "${__searchUrl}")
  local __spaceSize
  __spaceSize=$(jq -r '.totalSize'<<<"${__curlResult}")

  # Some output
  #printf "The space \"%s\" has %6s %s.\n" "${SPACEKEY}" "${__spaceSize}" "${__type}s.\n"
  eval "$__result"="'${__spaceSize}'"
}

getSpaceSize "page" SIZE_PAGE
getSpaceSize "attachment" SIZE_ATTACHMENT
getSpaceSize "blogpost" SIZE_BLOG
getSpaceSize "comment" SIZE_COMMENT

SIZE_TOTAL=$((SIZE_PAGE + SIZE_ATTACHMENT + SIZE_BLOG + SIZE_COMMENT))

# Some output
printf "\n"
printf "The space \"%s\" has %6s pages.\n" "${SPACEKEY}" "${SIZE_PAGE}"
printf "The space \"%s\" has %6s attachments.\n" "${SPACEKEY}" "${SIZE_ATTACHMENT}"
printf "The space \"%s\" has %6s blogposts.\n" "${SPACEKEY}" "${SIZE_BLOG}"
printf "The space \"%s\" has %6s comments.\n" "${SPACEKEY}" "${SIZE_COMMENT}"
printf "\nA total of %6s elements.\n" "${SIZE_TOTAL}"
