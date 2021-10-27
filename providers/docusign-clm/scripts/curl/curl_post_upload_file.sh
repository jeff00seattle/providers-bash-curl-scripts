#!/usr/bin/env bash

CURL_REQUEST="POST"

if [ -z "${DOCUSIGN_ACCESS_TOKEN}" ]
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

if [ ${VERBOSE} = true ]
  then
    echo -e '\n-------------------------\n'

    echo "  UPLOAD_HREF:   ${UPLOAD_HREF}"

    echo -e '\n-------------------------\n'
fi

CURL_CMD="curl "${UPLOAD_HREF}"
  --request ${CURL_REQUEST}
  ${CURL_VERBOSE}
  --write-out 'HTTPSTATUS:%{http_code}'
  --silent
  --header 'authorization: Bearer ${DOCUSIGN_ACCESS_TOKEN}'
  --header 'Content-Type: ${FILE_MEME_TYPE}'
  --data-binary @'${FILE_PATH}'
"

source ../../../shared/curl/curl_http_response.sh
