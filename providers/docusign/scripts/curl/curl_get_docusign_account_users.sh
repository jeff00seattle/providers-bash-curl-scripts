#!/usr/bin/env bash

CURL_REQUEST="GET"

if [ -z "${DOCUSIGN_ACCESS_TOKEN}" ]
  then
    echo "Missing ACCESS_TOKEN"; exit 1
fi

CURL_VERBOSE=""
if [ ${VERBOSE} = true ]
  then
    CURL_VERBOSE="--verbose"
fi

CURL_URL="${DOCUSIGN_API_BASE_URL}/restapi/${DOCUSIGN_API_VERSION}/accounts/${DOCUSIGN_ACCOUNT_ID}/users"

CURL_CMD="curl \"${CURL_URL}\"
  --request ${CURL_REQUEST}
  ${CURL_VERBOSE}
  --write-out 'HTTPSTATUS:%{http_code}'
  --silent
  --header \"authorization: Bearer ${DOCUSIGN_ACCESS_TOKEN}\"
"

source ../../../shared/curl/curl_http_response.sh
