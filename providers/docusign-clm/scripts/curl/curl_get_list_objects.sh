#!/usr/bin/env bash

CURL_REQUEST="GET"

if [ -z "${DOCUSIGN_ACCOUNT_ID}" ]
  then
    echo "Missing DOCUSIGN_ACCOUNT_ID" ; usage ; exit 1
fi

CURL_URL=""
if [ ! -z "${OBJECTS_TYPE}" ] && [ ! -z "${OBJECTS_ID}" ]
  then
    if [ ${VERBOSE} = true ]
      then
        echo "  OBJECTS_TYPE:           ${OBJECTS_TYPE}"
        echo "  OBJECTS_ID:             ${OBJECTS_ID}"
        echo "  SPRINGCM_API_BASE_URL:  ${SPRINGCM_API_BASE_URL}"
    fi

    CURL_URL="${SPRINGCM_API_BASE_URL}/${SPRINGCM_API_VERSION}${DOCUSIGN_ACCOUNT_ID}//folders/${OBJECTS_ID}/${OBJECTS_TYPE}"
fi

if [ -z "${CURL_URL}" ]
  then
    source ./curl/curl_get_root_folder.sh

    if [ ${OBJECTS_TYPE} == "documents" ]
      then
        CURL_URL=$(echo ${HTTP_BODY} | jq '.Documents.Href')
    fi
    if [ ${OBJECTS_TYPE} == "folders" ]
      then
        CURL_URL=$(echo ${HTTP_BODY} | jq '.Folders.Href')
    fi
fi

if [ -z "${DOCUSIGN_ACCESS_TOKEN}" ]
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
