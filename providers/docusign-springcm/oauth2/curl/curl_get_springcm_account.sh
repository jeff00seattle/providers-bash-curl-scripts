#!/usr/bin/env bash

CURL_REQUEST="GET"

if [ -z "${ACCESS_TOKEN}" ];
  then
    echo "Missing ACCESS_TOKEN"; exit 1
fi

if [ -z "${API_AUTH_URL}" ]
  then
    echo "Missing API_AUTH_URL" ; exit 1
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

echo -e '\n-------------------------\n'

echo "  API_BASE_URL:   ${API_BASE_URL}"

CURL_URL="${API_AUTH_URL}/api/v1/account"

echo "  CURL_URL:       ${CURL_URL}"

echo -e '\n-------------------------\n'

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
