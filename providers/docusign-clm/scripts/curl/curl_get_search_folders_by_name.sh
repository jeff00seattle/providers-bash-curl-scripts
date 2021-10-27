#!/usr/bin/env bash

if [ -z "${DOCUSIGN_ACCESS_TOKEN}" ]
  then
    echo "Missing ACCESS_TOKEN"; exit 1
fi

if [ -z "${CURL_REQUEST}" ]
  then
    echo "Missing CURL_REQUEST" ; exit 1
fi

CURL_VERBOSE=""
if [ ${VERBOSE} = true ]
  then
    CURL_VERBOSE="--verbose"
fi

CURL_URL="${PROTOCOL}://${HOSTNAME}/${PATHNAME}"

if [ ${VERBOSE} = true ]
  then
    echo -e '\n-------------------------\n'

    echo "  DOCUSIGN_ACCESS_TOKEN:      ${DOCUSIGN_ACCESS_TOKEN}"
    echo "  CURL_URL:    ${CURL_URL}"

    echo -e '\n-------------------------\n'
fi

CURL_CMD="curl \"${CURL_URL}\"
  --request ${CURL_REQUEST}
  ${CURL_VERBOSE}
  --write-out 'HTTPSTATUS:%{http_code}'
  --silent
  --header \"Authorization: Bearer ${DOCUSIGN_ACCESS_TOKEN}\"
  --header \"Content-Type: application/json\"
"

if [ ${VERBOSE} = true ]
  then
    echo "  CURL_CMD: ${CURL_CMD}"
fi

source ../../../shared/curl/curl_http_response.sh
