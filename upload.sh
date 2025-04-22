#!/bin/bash

# Requirements:
# - Windows Commandline
# - Cygwin + curl (Intune-Client)
#   - Alternative: https://curl.se/windows/
#
# (c) 2024 Oliver Glowa (glo03) / Arvato Systems GmbH
#
# - https://confluence.atlassian.com/confkb/using-the-confluence-rest-api-to-upload-an-attachment-to-one-or-more-pages-1014274390.html
#
# Call:
# ./upload.sh <PAGE_ID> <ATTACHMENT_FILE>
#

source ./common/env-restapi.sh

if [ "$1" != "" ]; then
  PAGE_ID=$1
fi

if [ "$2" != "" ]; then
  ATTACHMENT_FILE=$2
fi

echo "Do the upload"
echo "Page ID: ${PAGE_ID}"
echo "File: ${ATTACHMENT_FILE}"

curl -s -H "${CONF_AUTH}" -X POST -H "X-Atlassian-Token: no-check" -F "file=@${ATTACHMENT_FILE}" -F "comment=attached at ${TS}" ${CONF_RESTAPI_URL}/${PAGE_ID}/child/attachment?allowDuplicated=true | jq -r
