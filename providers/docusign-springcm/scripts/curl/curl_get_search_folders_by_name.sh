#!/usr/bin/env bash

CURL_REQUEST="GET"

if [ -z "${ACCESS_TOKEN}" ]
  then
    echo "Missing ACCESS_TOKEN"; exit 1
fi
echo ACCESS_TOKEN=${ACCESS_TOKEN}

if [ -z "${CURL_URL}" ]
  then
    echo "Missing curl href" ; exit 1
fi

if [ -z "${CURL_REQUEST}" ]
  then
    echo "Missing curl request" ; exit 1
fi

CURL_VERBOSE=""
if [ ${VERBOSE} = true ]
  then
    CURL_VERBOSE="--verbose"
fi

if [ ${VERBOSE} = true ]
  then
    echo "  CURL_URL: ${CURL_URL}"
fi

CURL_CMD="curl '${CURL_URL}'
  --request ${CURL_REQUEST}
  ${CURL_VERBOSE}
  --write-out 'HTTPSTATUS:%{http_code}'
  --silent
  --header \"Authorization: Bearer ${ACCESS_TOKEN}\"
  --header \"Content-Type: application/json\"
"

if [ ${VERBOSE} = true ]
  then
    echo "  CURL_CMD: ${CURL_CMD}"
fi

source ../../../shared/curl/curl_http_response.sh
