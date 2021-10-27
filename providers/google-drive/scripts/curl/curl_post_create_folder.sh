#!/usr/bin/env bash

CURL_REQUEST="POST"

if [ -z "${ACCESS_TOKEN}" ]
  then
    echo "Missing ACCESS_TOKEN"; exit 1
fi

if [ -z "${FOLDER}" ]
  then
    echo "Provide --folder" ; usage ; exit 1
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
  --header \"authorization: Bearer ${ACCESS_TOKEN}\"
  --header \"cache-control: no-cache\"
  --header \"content-type: application/json; charset=utf-8\"
  --header \"Accept: application/json\"
  --data '{\"mimeType\":\"application\/vnd.google-apps.folder\", \"name\": \"${FOLDER}\", \"parents\": [\"${PARENT}\"], \"properties\": {\"title\": \"FOO\"}}'
"

source ../../../shared/curl/curl_http_response.sh
