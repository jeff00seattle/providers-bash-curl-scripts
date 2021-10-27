#!/usr/bin/env bash

CURL_REQUEST="DELETE"

if [ -z "${ACCESS_TOKEN}" ]
  then
    echo "Missing ACCESS_TOKEN"; exit 1
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

# Delete a folder that is not empty by recursively deleting the folder and all of its content.
CURL_CMD="curl \"${PROTOCOL}://${API_HOSTNAME}/${PATHNAME}\"
  --request ${CURL_REQUEST}
  ${CURL_VERBOSE}
  $CURL_QUERY
  --write-out 'HTTPSTATUS:%{http_code}'
  --silent
  --header \"authorization: Bearer ${ACCESS_TOKEN}\"
"

source ../../../shared/curl/curl_http_response.sh
