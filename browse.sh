#!/bin/bash

# Requirements:
# - Windows Commandline
# - Cygwin + curl (Intune-Client)
#   - Alternative: https://curl.se/windows/
#
# (c) 2024 Oliver Glowa (glo03) / Arvato Systems GmbH
#
# Call:
# ./browse.sh
#

source ./common/env-restapi.sh

REQ_01="${CONF_RESTAPI_URL}?expand=space&limit=10"
REQ_02="${CONF_RESTAPI_URL}/scan?expand=space&limit=10"
REQ_03="${CONF_RESTAPI_URL}?expand=space&limit=10&spaceKey=NMAS"
REQ_04="${CONF_RESTAPI_URL}/scan?expand=space&limit=10&spaceKey=NMAS"

execBrowse()  {
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

execBrowse "${REQ_01}" "${RESP_RESULTS}" "Browse OLD Variant"
execBrowse "${REQ_02}" "${RESP_RESULTS}" "Scan NEW Variant"
execBrowse "${REQ_03}" "${RESP_RESULTS}" "Browse OLD Variant with space key"
execBrowse "${REQ_04}" "${RESP_RESULTS}" "Scan NEW Variant with space key"

