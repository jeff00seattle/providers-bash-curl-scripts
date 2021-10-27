#!/usr/bin/env bash

CURL_REQUEST="GET"

if [ -z "${DOCUSIGN_ACCESS_TOKEN}" ]
  then
    echo "Missing ACCESS_TOKEN"; exit 1
fi

if [ -z "${SPRINGCM_API_BASE_URL}" ]
  then
    echo "Provide api-base-url" ; usage ; exit 1
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

CURL_CMD="curl '${CURL_URL}'
  --request ${CURL_REQUEST}
  ${CURL_VERBOSE}
  --write-out 'HTTPSTATUS:%{http_code}'
  --silent
  --header \"Authorization: Bearer ${DOCUSIGN_ACCESS_TOKEN}\"
  --header \"Accept: application/json\"
  --connect-timeout 60
"

source ../../../shared/curl/curl_http_response.sh
