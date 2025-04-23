#!/bin/bash

# Requirements:
# - Windows Commandline
# - Cygwin + curl (Intune-Client)
#   - Alternative: https://curl.se/windows/
#
# (c) 2024 Oliver Glowa (glo03) / Arvato Systems GmbH
#
# !!!! Works only with privat access token (PAT) !!!!

if [ -f ~/.restapi/my.conf ]; then
  source ~/.restapi/my.conf
else
  printf "No personal config found in ~/.restapi/my.conf!"
  exit 11
fi

CONF_BASE_URL=${MY_BASE_URL}
CONF_AUTH="Authorization: Bearer ${MY_PAT}"

# Check
if [ "${CONF_AUTH}" = "" ]; then
	printf "No PAT (personal access token) in environment defined!"
	exit 10
fi

TS=`date`

CONF_RESTAPI_URL=${CONF_BASE_URL}/rest/api/content
CONF_SEARCH_URL=${CONF_BASE_URL}/rest/api/search
DL_DIR=${TEMP}

REQP_LIGHT='&expand=space'
REQP_FULL='&expand=body.storage,version,space'

RESP_SINGLE='.id + " [" + .space.key + "] \"" + .title + "\""'
RESP_RESULTS='.results[]| .id + " [" + .space.key + "] \"" + .title + "\""'
RESP_BODY_SINGLE='.id + " [" + .space.key + "] \"" + .title + "\"",.body.storage.value'
RESP_BODY_RESULTS='.results[]| .id + " [" + .space.key + "] \"" + .title + "\"" + "\n#BODY START#\n" + .body.storage.value + "\n#BODY END#\n"'


