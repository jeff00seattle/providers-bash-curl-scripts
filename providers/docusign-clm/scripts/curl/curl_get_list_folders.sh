#!/usr/bin/env bash

CURL_REQUEST="GET"

if [ -z "${DOCUSIGN_ACCOUNT_ID}" ]
  then
    echo "Missing DOCUSIGN_ACCOUNT_ID" ; usage ; exit 1
fi

CURL_URL=""
if [ ! -z "${OBJECTS_ID}" ]
  then
    echo "7"
    CURL_URL="${SPRINGCM_API_BASE_URL}/${SPRINGCM_API_VERSION}/${DOCUSIGN_ACCOUNT_ID}/folders/${OBJECTS_ID}/folders"
fi

echo "10  CURL_URL: ${CURL_URL}"

if [ -z "${CURL_URL}" ]
  then
    echo "13"
    source ./curl/curl_get_root_folder.sh
    echo "17"
    echo "${HTTP_BODY}"

    echo "20"
    CURL_URL=$(echo ${HTTP_BODY} | jq '.Folders.Href')
fi

echo "22"

if [ -z "${DOCUSIGN_ACCESS_TOKEN}" ]
  then
    echo "Missing ACCESS_TOKEN"; exit 1
fi

if [ -z "${CURL_REQUEST}" ]
  then
    echo "Missing CURL_REQUEST" ; exit 1
fi

CURL_VERBOSE=""
if [ ${VERBOSE} = true ]
  then
    CURL_VERBOSE="--verbose"
fi

if [ ${VERBOSE} = true ]
  then
    echo -e '\n-------------------------\n'

    echo "  CURL_URL:   ${CURL_URL}"

    echo -e '\n-------------------------\n'
fi

CURL_CMD="curl \"${CURL_URL}\"
  --request ${CURL_REQUEST}
  ${CURL_VERBOSE}
  --write-out 'HTTPSTATUS:%{http_code}'
  --silent
  --header \"Authorization: Bearer ${DOCUSIGN_ACCESS_TOKEN}\"
  --header \"Accept: application/json\"
  --connect-timeout 60
"

source ../../../shared/curl/curl_http_response.sh
