#!/bin/bash

# Requirements:
# - Windows Commandline
# - Cygwin + curl (Intune-Client)
#   - Alternative: https://curl.se/windows/
#
# (c) 2024 Oliver Glowa (glo03) / Arvato Systems GmbH
#
# Call:
# ./getInfo.sh <PAGE_ID>
#

source ./common/env-restapi.sh

# Prepare & check files
PREFIX_FILE=$(basename -s .sh "${0}")

if [ "$1" != "" ]; then
  IN_FILE="${1}"
  IN_DIR=$(dirname "${IN_FILE}")
  OUT_DIR=$(dirname "${0}")"/out/${PREFIX_FILE}"
  OUT_FILE="${OUT_DIR}/"$(basename "${IN_FILE}")"-${TS}.csv"
else
  IN_DIR=$(dirname "${0}")"/in"
  IN_FILE="${IN_DIR}/${PREFIX_FILE}.in"
  OUT_DIR=$(dirname "${0}")"/out/${PREFIX_FILE}"
  OUT_FILE="${OUT_DIR}/${PREFIX_FILE}-${TS}.csv"
fi

if [ ! -s "${IN_FILE}" ]; then
  printf "Missing or empty input file: %s\n" "${IN_FILE}"
  exit 11
fi

mkdir -p "${OUT_DIR}"
if [ ! -d "${OUT_DIR}" ]; then
  printf "Failed to create output directory: %s\n" "${OUT_DIR}"
  exit 12
fi

# Some output
printf "\nread from : %s\n" "${IN_FILE}"
printf "write to  : %s\n\n" "${OUT_FILE}"

# write file header
echo "${RESP_CSV_SINGLE_HEADER}" > "${OUT_FILE}"

IDX=0

while IFS= read -r __lineIn
do
  __pageId="${__lineIn}"
  ((IDX=IDX+1))
  __lineOut="${IDX}"

  __infoUrl="${CONF_RESTAPI_URL}/${__pageId}?${REQP_LIGHT}"
  __permUrl="${CONF_RESTAPI_URL}/${__pageId}/restriction/byOperation?${REQP_PERM}"
  __labelUrl="${CONF_RESTAPI_URL}/${__pageId}/label"

  printf "%s.\n%s\n%s\n%s\n" "${IDX}" "${__infoUrl}" "${__permUrl}" "${__labelUrl}"

  # Get the result
  __curlResultInfo=$(curl -s -H "${CONF_AUTH}" "${__infoUrl}")
  __lineOut+=";"$(jq -r "${RESP_CSV_SINGLE}"<<<"${__curlResultInfo}")

  # Get labels
  __curlResultLabel=$(curl -s -H "${CONF_AUTH}" "${__labelUrl}")
  __lineOut+=";"$(jq -r "${RESP_LABEL}"<<<"${__curlResultLabel}")

  # Get restrictions
  __curlResultPerm=$(curl -s -H "${CONF_AUTH}" "${__permUrl}")
  __lineOut+=";"$(jq -r "${PERM_READ_USER}"<<<"${__curlResultPerm}")
  __lineOut+=$(jq -r "${PERM_READ_GROUP}"<<<"${__curlResultPerm}")
  __lineOut+=";"$(jq -r "${PERM_UPDATE_USER}"<<<"${__curlResultPerm}")
  __lineOut+=$(jq -r "${PERM_UPDATE_GROUP}"<<<"${__curlResultPerm}")

  # shellcheck disable=SC2005
  echo $(tr -d '\n\r'<<<"${__lineOut}")>>"${OUT_FILE}"

done < "${IN_FILE}"