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

CURL_QUERY=""
if [ ! -z "$QUERY" ]
  then
    CURL_QUERY="-G --data-urlencode \"$QUERY\""
fi
#echo CURL_QUERY=$CURL_QUERY

CURL_VERBOSE=""
if [ ${VERBOSE} = true ]
  then
    CURL_VERBOSE="--verbose"
fi

CURL_CMD="curl \"${PROTOCOL}://${API_HOSTNAME}/${PATHNAME}\"
  --request ${CURL_REQUEST}
  ${CURL_VERBOSE}
  $CURL_QUERY
  --write-out 'HTTPSTATUS:%{http_code}'
  --silent
  --header \"authorization: Bearer ${ACCESS_TOKEN}\"
  --header \"cache-control: no-cache\"
  --header \"content-type: application/json; charset=utf-8\"
  --header \"Accept: application/json\"
  --data '{\"name\": \"${FOLDER}\", \"parent\": {\"id\": \"${PARENT}\"}}'
"

source ../../../shared/curl/curl_http_response.sh
