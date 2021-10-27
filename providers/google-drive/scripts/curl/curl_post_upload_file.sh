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

echo FILE_PATH=${FILE_PATH}

FILE_NAME=$(eval "basename ${FILE_PATH}")
FILE_TYPE=$(eval "file --brief --mime ${FILE_PATH}")

echo FILE_NAME=${FILE_NAME}
echo FILE_TYPE=$FILE_TYPE

CURL_CMD="curl \"${PROTOCOL}://${HOSTNAME}/${PATHNAME}\"
  --request ${CURL_REQUEST}
  ${CURL_VERBOSE}
  --write-out 'HTTPSTATUS:%{http_code}'
  --silent
  --header \"authorization: Bearer ${ACCESS_TOKEN}\"
  --header \"cache-control: no-cache\"
  --form \"metadata={name: '${FILE_NAME}', parents: ['${PARENT}']};type=application/json;charset=UTF-8\" \
  --form \"file=@${FILE_PATH};type=$FILE_TYPE\"
"

source ../../../shared/curl/curl_http_response.sh

