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

# Set the maximum level of recursion
MAX_LEVEL=2

# Check
if [ "$1" != "" ]; then
    PAGE_ID=$1
  else
    if [ "${PAGE_ID}" = "" ]; then
        printf "\nNo PAGE_ID given!\n"
        exit 30
    fi
fi

# Set current level
LEVEL=0
if [ "$2" != "" ]; then
  LEVEL=$2
  ((LEVEL=LEVEL+1))
fi

STOP_BRANCH=0
if [ ${LEVEL} -ge ${MAX_LEVEL} ]; then
  STOP_BRANCH=1
fi

# Set the indentation by level
INDENT=$(printf "%-${LEVEL}s")$(printf "%-${LEVEL}s")

# Read the page
PARENT_URL="${CONF_RESTAPI_URL}/${PAGE_ID}?expand=space"
PARENT_RESULT=$(curl -s -H "${CONF_AUTH}" "${PARENT_URL}")
PARENT_INFO=$(jq -r '.id + " [" + .space.key + "] \"" + .title +"\""'<<<"${PARENT_RESULT}")

# Get the children URL
CHILD_URL=$(jq -r '._expandable.children'<<<"${PARENT_RESULT}")
CHILD_URL=${CONF_BASE_URL}${CHILD_URL}"/page?expand=space"

# Read the child pages
CHILD_RESULT=$(curl -s -H "${CONF_AUTH}" "${CHILD_URL}")
CHILD_MAX=$(jq -r '.size'<<<"${CHILD_RESULT}")

# Some output
printf "\n%sLEV.%s\n" "${INDENT}" "${LEVEL}"
printf "%s│\t\t\t\t%s\n" "${INDENT}" "${PARENT_URL}"
printf "%s│\t\t\t\t%s\n" "${INDENT}" "${CHILD_URL}"
printf "%s├- Childs : %s (LEV.%s)\n" "${INDENT}" "${CHILD_MAX}" "${LEVEL}"

CHILD_IDX=-1
jq -r '.results[] | .id + " " + .space.key + " " + .title +""'<<<"${CHILD_RESULT}" |
{
  while read -r CHILD_PAGE_ID CHILD_SPACE CHILD_TITLE ; do
    # Loop through the child pages
    ((CHILD_IDX=CHILD_IDX+1))

    # Some output
    printf "%s│\n" "${INDENT}"
    printf "%s├- PAGE   : %s\n" "${INDENT}" "${PARENT_INFO}"
    printf "%s└- %s.CHILD: %s [%s] \"%s\"\n" "${INDENT}" "${CHILD_IDX}" "${CHILD_PAGE_ID}" "${CHILD_SPACE}" "${CHILD_TITLE}"

    if [ ${STOP_BRANCH} -eq 0 ]; then
      # Call the script recursively for the next level
      ./"$0" "${CHILD_PAGE_ID}" ${LEVEL}
    else
      # stop the recursion for this branch
      printf "%s\t\t\t\t-> ## STOP_BRANCH ON LEV.%s ##\n" "${INDENT}" "${LEVEL}"
    fi
  done

  if [ ${CHILD_IDX} -lt 0 ]; then
    # Branch has no children
    printf "%s├- PAGE   : %s\n" "${INDENT}" "${PARENT_INFO}"
    printf "%s└- x.CHILD: No children found\n" "${INDENT}"
  fi
}