#!/bin/bash

# Requirements:
# - Windows Commandline
# - Cygwin + curl (Intune-Client)
#   - Alternative: https://curl.se/windows/
#
# (c) 2024 Oliver Glowa (glo03) / Arvato Systems GmbH
#
# Call:
# ./read.sh
#

source ./common/env-restapi.sh

PAGE_ID=591855803
PAGE_NAME_01="title=REST-API%2001"
PAGE_NAME_02="spaceKey=NMAS&title=98-Playground"

REQ_01="${CONF_RESTAPI_URL}/${PAGE_ID}?${REQP_LIGHT}"
REQ_02="${CONF_RESTAPI_URL}?${PAGE_NAME_01}${REQP_FULL}"
REQ_03="${CONF_RESTAPI_URL}?${PAGE_NAME_02}${REQP_FULL}"

execRead()  {
  local __url=$1
  local __expand=$2
  local __msg=$3

  # Some output
  printf "\n%s\n%s\n%s\n" "--------" "${__msg}" "--------"
  printf "%s\n\n" "${__url}"

  # Get the results
  local __curlResult
  __curlResult=$(curl -s -H "${CONF_AUTH}" "${__url}")

  # Print the result
  jq -r "${__expand}"<<<"${__curlResult}"
}

execRead "${REQ_01}" "${RESP_BODY_SINGLE}" "Get by Page ID"
execRead "${REQ_02}" "${RESP_BODY_RESULTS}" "Get by Page Title"
execRead "${REQ_03}" "${RESP_BODY_RESULTS}" "Get by Space and Page Title"
