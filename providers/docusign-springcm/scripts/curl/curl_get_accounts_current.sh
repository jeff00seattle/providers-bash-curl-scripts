#!/usr/bin/env bash

CURL_REQUEST="GET"

if [ -z "${ACCESS_TOKEN}" ]
  then
    echo "Missing ACCESS_TOKEN"; exit 1
fi

CURL_VERBOSE=""
if [ ${VERBOSE} = true ]
  then
    CURL_VERBOSE="--verbose"
fi

ACCOUNTS_CURRENT_HREF="${API_BASE_URL}/${API_VERSION}/accounts/current"

CURL_CMD="curl '$ACCOUNTS_CURRENT_HREF'
  --request ${CURL_REQUEST}
  ${CURL_VERBOSE}
  --write-out 'HTTPSTATUS:%{http_code}'
  --silent
  --header \"authorization: Bearer ${ACCESS_TOKEN}\"
"

source ../../../shared/curl/curl_http_response.sh
