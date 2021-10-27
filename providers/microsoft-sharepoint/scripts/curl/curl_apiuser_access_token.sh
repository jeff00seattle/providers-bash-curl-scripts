#!/usr/bin/env bash

if [ -z "${CLIENT_ID}" ]
  then
    echo "Provide --client-id" ; usage ; exit 1
fi

if [ -z "${CLIENT_SECRET}" ]
  then
    echo "Provide --client-secret" ; usage ; exit 1
fi

if [ -z "${CURL_REQUEST}" ]
  then
    CURL_REQUEST="POST"
fi

CURL_VERBOSE=""
if [ ${VERBOSE} = true ]
  then
    CURL_VERBOSE=" --verbose"
fi

if [ ${VERBOSE} = true ]
  then
    echo "CLIENT_ID=${CLIENT_ID}"
    echo "CLIENT_SECRET=${CLIENT_SECRET}"
fi

CURL_CMD="curl $APIUSER_URL
  --request POST
  ${CURL_VERBOSE}
  --write-out 'HTTPSTATUS:%{http_code}'
  --silent
  --header \"Content-Type: application/json; charset=utf-8\"
  --connect-timeout 60
  --data '{\"client_id\":\"${CLIENT_ID}\",\"client_secret\":\"${CLIENT_SECRET}\"}'
"

source ../../../shared/curl/curl_http_response.sh
