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

CURL_CMD="curl -SLG \"${AUTH_USER_URL}\"
  --request ${CURL_REQUEST}
  ${CURL_VERBOSE}
  --write-out 'HTTPSTATUS:%{http_code}'
  --silent
  --header \"authorization: Bearer ${ACCESS_TOKEN}\"
"

source ../../../shared/curl/curl_http_response.sh
