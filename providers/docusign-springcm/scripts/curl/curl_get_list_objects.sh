#!/usr/bin/env bash

CURL_REQUEST="GET"

CURL_URL=""
if [ ! -z "${OBJECTS_TYPE}" ] && [ ! -z "${OBJECTS_ID}" ]
  then
    if [ ${VERBOSE} = true ]
      then
        echo "  OBJECTS_TYPE: $OBJECTS"
        echo "  OBJECTS_ID: ${OBJECTS_ID}"
        echo "  API_BASE_URL: ${API_BASE_URL}"
    fi

    CURL_URL="${API_BASE_URL}/${API_VERSION}/folders/${OBJECTS_ID}/${OBJECTS_TYPE}"
fi

if [ -z "${CURL_URL}" ]
  then
    source ./curl/curl_get_root_folder.sh

    if [ ${OBJECTS_TYPE} = "documents" ]
      then
        CURL_URL=$(echo ${HTTP_BODY} | jq '.Documents.Href')
    fi
    if [ ${OBJECTS_TYPE} = "folders" ]
      then
        CURL_URL=$(echo ${HTTP_BODY} | jq '.Folders.Href')
    fi
fi

if [ -z "${ACCESS_TOKEN}" ]
  then
    echo "Missing ACCESS_TOKEN"; exit 1
fi

CURL_VERBOSE=""
if [ ${VERBOSE} = true ]
  then
    CURL_VERBOSE="--verbose"
fi

if [ -z "${CURL_REQUEST}" ]
  then
    echo "Missing CURL_REQUEST" ; exit 1
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
