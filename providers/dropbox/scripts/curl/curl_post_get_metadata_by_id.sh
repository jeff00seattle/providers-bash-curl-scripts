#!/usr/bin/env bash

CURL_REQUEST="POST"

if [ -z "${ACCESS_TOKEN}" ]
  then
    echo "Missing ACCESS_TOKEN"; exit 1
fi
# echo ACCESS_TOKEN=${ACCESS_TOKEN}

CURL_VERBOSE=""
if [ ${VERBOSE} = true ]
  then
    CURL_VERBOSE="--verbose"
fi

CURL_CMD="curl \"${PROTOCOL}://${HOSTNAME}/${PATHNAME}\"
  --request ${CURL_REQUEST}
  ${CURL_VERBOSE}
  --write-out 'HTTPSTATUS:%{http_code}'
  --silent
  --header \"authorization: Bearer ${ACCESS_TOKEN}\"
  --header \"cache-control: no-cache\"
  --header \"Content-Type: application/json\"
  --data '{ \"path\": \"c\",
    \"include_media_info\": true,
    \"include_has_explicit_shared_members\": true
  }'
"

source ../../../shared/curl/curl_http_response.sh
