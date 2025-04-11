#!/bin/bash

# Requirements:
# - Windows Commandline
# - Cygwin + curl (Intune-Client)
#   - Alternative: https://curl.se/windows/
#
# (c) 2024 Oliver Glowa (glo03) / Arvato Systems GmbH
#

source ./common/env-restapi.sh


REQ_01="${CONF_RESTAPI_URL}?expand=space&limit=10"
REQ_02="${CONF_RESTAPI_URL}/scan?expand=space&limit=10"
REQ_03="${CONF_RESTAPI_URL}?expand=space&limit=10&spaceKey=NMAS"
REQ_04="${CONF_RESTAPI_URL}/scan?expand=space&limit=10&spaceKey=NMAS"

echo -e "\n--------"
echo "Browse OLD Variant"
echo "--------"
echo "${REQ_01}"

curl -s -H "${CONF_AUTH}" "${REQ_01}" | jq -r "${RESP_RESULTS}"

echo -e "\n--------"
echo "Scan NEW Variant"
echo "--------"
echo "${REQ_02}"

curl -s -H "${CONF_AUTH}" "${REQ_02}" | jq -r "${RESP_RESULTS}"

echo -e "\n--------"
echo "Browse OLD Variant with space key"
echo "--------"
echo "${REQ_03}"

curl -s -H "${CONF_AUTH}" "${REQ_03}" | jq -r "${RESP_RESULTS}"

echo -e "\n--------"
echo "Scan NEW Variant with space key"
echo "--------"
echo "${REQ_04}"

curl -s -H "${CONF_AUTH}" "${REQ_04}" | jq -r "${RESP_RESULTS}"
