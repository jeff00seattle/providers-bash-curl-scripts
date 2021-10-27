#!/usr/bin/env bash

CURL_REQUEST="GET"

if [ -z "${ACCESS_TOKEN}" ]
  then
    echo "Missing ACCESS_TOKEN"; exit 1
fi

if [ -z "${API_BASE_URL}" ]
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

CURL_CMD="curl \"${API_BASE_URL}/${API_VERSION}/workflowdefinitions\"
  --request ${CURL_REQUEST}
  ${CURL_VERBOSE}
  --write-out 'HTTPSTATUS:%{http_code}'
  --silent
  --header \"Authorization: Bearer ${ACCESS_TOKEN}\"
  --header \"Accept: application/json\"
  --connect-timeout 60
"

source ../../../shared/curl/curl_http_response.sh
