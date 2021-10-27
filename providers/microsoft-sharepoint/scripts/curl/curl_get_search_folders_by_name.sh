#!/usr/bin/env bash

if [ -z "${ACCESS_TOKEN}" ]
  then
    echo "Missing ACCESS_TOKEN"; exit 1
fi
echo ACCESS_TOKEN=${ACCESS_TOKEN}

if [ -z "${FOLDER}" ]
  then
    echo "Provide --folder" ; usage ; exit 1
fi

CURL_VERBOSE=""
if [ ${VERBOSE} = true ]
  then
    CURL_VERBOSE=" --verbose"
fi

CURL_CMD="curl \"${PROTOCOL}://${HOSTNAME}/${PATHNAME}\"
  --request ${CURL_REQUEST}
  ${CURL_VERBOSE}
  --write-out 'HTTPSTATUS:%{http_code}'
  --silent
  --header \"Authorization: Bearer ${ACCESS_TOKEN}\"
  --header \"Content-Type: application/json\"
  --data '{ \"query\": \"${FOLDER}\", \"options\": { \"path\": \"${PARENT}\" } }'
"

if [ ${VERBOSE} = true ]
  then
    echo "  CURL_CMD: ${CURL_CMD}"
fi

source ../../../shared/curl/curl_http_response.sh
