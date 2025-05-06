#!/bin/bash

# Requirements:
# - Windows Commandline
# - Cygwin + curl (Intune-Client)
#   - Alternative: https://curl.se/windows/
#
# (c) 2024 Oliver Glowa (glo03) / Arvato Systems GmbH
#
# Call:
# ./list-spaces.sh
#

source ./common/env-restapi.sh

getSpaceList() {
  local __type=$1
  local __limit=$2
  local __expand=${RESP_CSV_SPACE_RESULTS}

  local __url="${CONF_BASE_URL}/rest/api/space?expand=homepage,description.plain,metadata.labels&type=${__type}&limit=${__limit}"

  # Some output
  printf "\n%s\n%s\n%s\n" "--------" "${__type}" "--------"
  printf "%s\n\n" "${__url}"


  # Get the results
  local __curlResult
  __curlResult=$(curl -s -H "${CONF_AUTH}" "${__url}")

  # Print the result
  jq -r "${__expand}"<<<"${__curlResult}"

}

# Some output
printf "\n"
getSpaceList "global" 100

printf "\n"
getSpaceList "personal" 200
