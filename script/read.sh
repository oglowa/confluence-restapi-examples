#!/bin/bash

# Requirements:
# - Windows Commandline
# - Cygwin + curl (Intune-Client)
#   - Alternative: https://curl.se/windows/
#
# (c) 2024 Oliver Glowa (glo03) / Arvato Systems GmbH
#

source ./common/env-restapi.sh

PAGE_ID=591855803
PAGE_NAME_01="title=REST-API%2001"
PAGE_NAME_02="spaceKey=NMAS&title=98"

REQ_01="${CONF_RESTAPI_URL}/${PAGE_ID}?${REQP_LIGHT}"
REQ_02="${CONF_RESTAPI_URL}?${PAGE_NAME_01}${REQP_FULL}"
REQ_03="${CONF_RESTAPI_URL}?${PAGE_NAME_02}${REQP_FULL}"

echo -e "\n--------"
echo "Get by Page ID"
echo "--------"
echo "${REQ_01}"

curl -s -H "${CONF_AUTH}" "${REQ_01}" | jq -r "${RESP_BODY_SINGLE}"

echo -e "\n--------"
echo "Get by Page Title"
echo "--------"
echo "${REQ_02}"

curl -s -H "${CONF_AUTH}" "${REQ_02}" | jq -r "${RESP_BODY_RESULTS}"
 #| sortc -k 2

echo -e "\n--------"
echo "Get by Space and Page Title"
echo "--------"
echo "${REQ_03}"

curl -s -H "${CONF_AUTH}" "${REQ_03}" | jq -r "${RESP_BODY_RESULTS}"



