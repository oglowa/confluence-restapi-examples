#!/bin/bash

# Requirements:
# - Windows Commandline
# - Cygwin + curl (Intune-Client)
#   - Alternative: https://curl.se/windows/
#
# (c) 2024 Oliver Glowa (glo03) / Arvato Systems GmbH
# 
# !!!! Works only with privat access token (PAT) !!!!

TS=`date`

CONF_AUTH="Authorization: Bearer ${CONF_PAT_TEST}"

CONF_BASE_URL_TEST=https://nma-s-confluence-test.arvato-systems.de
CONF_BASE_URL_INTE=https://nma-s-confluence-mig.arvato-systems.de
CONF_BASE_URL=${CONF_BASE_URL_TEST}

CONF_RESTAPI_URL=${CONF_BASE_URL}/rest/api/content
DL_DIR=${TEMP}

REQP_LIGHT='&expand=space'
REQP_FULL='&expand=body.storage,version,space'

RESP_SINGLE='.id + " " + .space.key + " " + .title'
RESP_RESULTS='.results[]| .id + " " + .space.key + " " + .title'
RESP_BODY_SINGLE='.id + " " + .space.key + " " + .title,.body.storage.value'
RESP_BODY_RESULTS='.results[]| .id + " " + .space.key + " " + .title + "\n" + .body.storage.value'


# Check
if [ "${CONF_AUTH}" = "" ]; then
	echo -e "No PAT (personal access token) in environment defined!"
	exit 10
fi
