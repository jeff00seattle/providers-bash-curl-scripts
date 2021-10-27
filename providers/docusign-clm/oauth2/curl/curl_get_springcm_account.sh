#!/usr/bin/env bash

CURL_REQUEST="GET"

if [ -z "${DOCUSIGN_ACCESS_TOKEN}" ];
  then
    echo "Missing DOCUSIGN_ACCESS_TOKEN" ; usage ; exit 1
fi

if [ -z "${SPRINGCM_API_AUTH_URL}" ]
  then
    echo "Missing SPRINGCM_API_AUTH_URL" ; usage ; exit 1
fi

if [ -z "${DOCUSIGN_ACCOUNT_ID}" ]
  then
    echo "Missing DOCUSIGN_ACCOUNT_ID" ; usage ; exit 1
fi

if [ -z "${CURL_REQUEST}" ]
  then
    echo "Missing CURL_REQUEST" ; exit 1
fi

echo "  VERBOSE:    ${VERBOSE}"

CURL_VERBOSE=""
if [ ${VERBOSE} = true ]
  then
    CURL_VERBOSE="--verbose"
fi

CURL_URL="${SPRINGCM_API_AUTH_URL}/api/${SPRINGCM_API_VERSION}/${DOCUSIGN_ACCOUNT_ID}/account"

if [ ${VERBOSE} = true ]
  then
    echo -e '\n-------------------------\n'

    echo "  CURL_URL:    ${CURL_URL}"

    echo -e '\n-------------------------\n'
fi

CURL_CMD="curl \"${CURL_URL}\"
  --request ${CURL_REQUEST}
  ${CURL_VERBOSE}
  --write-out 'HTTPSTATUS:%{http_code}'
  --silent
  --header \"Authorization: Bearer ${DOCUSIGN_ACCESS_TOKEN}\"
  --header \"Accept: application/json\"
  --connect-timeout 60
"

source ../../../shared/curl/curl_http_response.sh
