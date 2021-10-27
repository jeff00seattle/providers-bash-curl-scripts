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

echo -e '\n-------------------------\n'

echo "  API_BASE_URL:   ${API_BASE_URL}"
echo "  API_VERSION:    ${API_VERSION}"

CURL_URL="${API_BASE_URL}/${API_VERSION}/accounts/current"

echo "  CURL_URL:       ${CURL_URL}"

echo -e '\n-------------------------\n'

CURL_CMD="curl \"${CURL_URL}\"
  --request ${CURL_REQUEST}
  ${CURL_VERBOSE}
  --write-out 'HTTPSTATUS:%{http_code}'
  --silent
  --header \"authorization: Bearer ${ACCESS_TOKEN}\"
"

source ../../../shared/curl/curl_http_response.sh
