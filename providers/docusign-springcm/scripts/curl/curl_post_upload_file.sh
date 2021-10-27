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

FILE_NAME=$(eval "basename ${FILE_PATH}")
FILE_TYPE=$(eval "file --brief --mime ${FILE_PATH}")

CURL_CMD="curl '$UPLOAD_HREF'
  --request ${CURL_REQUEST}
  ${CURL_VERBOSE}
  --write-out 'HTTPSTATUS:%{http_code}'
  --silent
  --header 'authorization: Bearer ${ACCESS_TOKEN}'
  --header 'Content-Type: ${FILE_MEME_TYPE}'
  --data-binary @'${FILE_PATH}'
"

source ../../../shared/curl/curl_http_response.sh
