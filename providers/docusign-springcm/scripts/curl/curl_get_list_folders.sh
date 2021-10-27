#!/usr/bin/env bash

CURL_REQUEST="GET"

CURL_URL=""
if [ ! -z "${OBJECTS_ID}" ]
  then
    CURL_URL="${API_BASE_URL}/${API_VERSION}/folders/${OBJECTS_ID}/folders"
fi

if [ -z "${CURL_URL}" ]
  then
    source ./curl/curl_get_root_folder.sh
    CURL_URL=$(echo ${HTTP_BODY} | jq '.Folders.Href')
fi

if [ -z "${ACCESS_TOKEN}" ]
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

CURL_URL=$(echo ${CURL_URL} | sed "s/\"//g")

CURL_CMD="curl \"${CURL_URL}\"
  --request ${CURL_REQUEST}
  ${CURL_VERBOSE}
  --write-out 'HTTPSTATUS:%{http_code}'
  --silent
  --header \"Authorization: Bearer ${ACCESS_TOKEN}\"
  --header \"Accept: application/json\"
  --connect-timeout 60
"

source ../../../shared/curl/curl_http_response.sh
