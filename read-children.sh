#!/bin/bash

# Requirements:
# - Windows Commandline
# - Cygwin + curl (Intune-Client)
#   - Alternative: https://curl.se/windows/
#
# (c) 2024 Oliver Glowa (glo03) / Arvato Systems GmbH
#
# Call:
# ./read-children.sh <PAGE_ID>
#

source ./common/env-restapi.sh

# set the maximum level of recursion
MAX_LEVEL=2

PAGE_ID=532951146
#532951146 #98 Playground
#125380876 #Health%20and%Public

if [ "$1" != "" ]; then
  PAGE_ID=$1
fi

LEVEL=0
if [ "$2" != "" ]; then
  LEVEL=$2
  ((LEVEL=LEVEL+1))
fi

STOP_BRANCH=0
if [ ${LEVEL} -ge ${MAX_LEVEL} ]; then
  STOP_BRANCH=1
fi

# set the indentation by level
INDENT=$(printf "%-${LEVEL}s")$(printf "%-${LEVEL}s")

# read the page
PARENT_URL="${CONF_RESTAPI_URL}/${PAGE_ID}?expand=space"
CURL_RESULT=$(curl -s -H "${CONF_AUTH}" "${PARENT_URL}")
PARENT_INFO=$(jq -r '.id + " [" + .space.key + "] \"" + .title +"\""'<<<"${CURL_RESULT}")

# get the children URL
CHILD_URL=$(jq -r '._expandable.children'<<<"${CURL_RESULT}")
CHILD_URL=${CONF_BASE_URL}${CHILD_URL}"/page?expand=space"

# Some output
echo -e "\n${INDENT}LEV.${LEVEL}"
echo -e "${INDENT}│\t\t\t\t${PARENT_URL}"
echo -e "${INDENT}│\t\t\t\t${CHILD_URL}"

# read the child pages
CURL_RESULT=$(curl -s -H "${CONF_AUTH}" "${CHILD_URL}")

CHILD_IDX=-1
jq -r '.results[] | .id + " " + .space.key + " " + .title +""'<<<"${CURL_RESULT}" |
{
  while read -r CHILD_PAGE_ID CHILD_SPACE CHILD_TITLE ; do
    # looop through the child pages
    ((CHILD_IDX=CHILD_IDX+1))

    # some output
    echo "${INDENT}│"
    echo "${INDENT}├- PAGE   : ${PARENT_INFO}"
    echo "${INDENT}└- ${CHILD_IDX}.CHILD: ${CHILD_PAGE_ID} [${CHILD_SPACE}] \"${CHILD_TITLE}\""

    if [ ${STOP_BRANCH} -eq 0 ]; then
      # call the script recursively for the next level
      ./"$0" "${CHILD_PAGE_ID}" ${LEVEL}
    else
      # stop the recursion for this branch
      echo -e "${INDENT}           ## STOP_BRANCH ON LEV.${LEVEL} ##\n"
    fi
  done

  if [ ${CHILD_IDX} -lt 0 ]; then
    # branch has no children
    echo "${INDENT}├- PAGE   : ${PARENT_INFO}"
    echo -e "${INDENT}└- x.CHILD: No children found\n"
  fi
}