#!/usr/bin/env bash

CURL_REQUEST="POST"

if [ -z "${ACCESS_TOKEN}" ]
  then
    echo "Missing ACCESS_TOKEN"; exit 1
fi

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
  --data '{
    \"path\": \"${PARENT_ID}\",
    \"recursive\": ${RECURSIVE},
    \"limit\": ${LIMIT},
    \"include_media_info\": false,
    \"include_deleted\": false,
    \"include_has_explicit_shared_members\": false
  }'
"

source ../../../shared/curl/curl_http_response.sh
