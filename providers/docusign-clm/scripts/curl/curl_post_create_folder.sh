#!/usr/bin/env bash

CURL_REQUEST="POST"

if [ -z "${DOCUSIGN_ACCOUNT_ID}" ]
  then
    echo "Missing DOCUSIGN_ACCOUNT_ID" ; usage ; exit 1
fi

if [ -z "${DOCUSIGN_ACCESS_TOKEN}" ]
  then
    echo "Missing ACCESS_TOKEN"; exit 1
fi

if [ -z "${PARENT_CURL_HREF}" ]
  then
    echo "Provide in parent folder href" ; exit 1
fi

if [ -z "${FOLDER_NAME}" ]
  then
    echo "Provide --folder" ; usage ; exit 1
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

CURL_URL="${SPRINGCM_API_BASE_URL}/${SPRINGCM_API_VERSION}/${DOCUSIGN_ACCOUNT_ID}/folders"

if [ ${VERBOSE} = true ]
  then
    echo -e '\n-------------------------\n'

    echo "  CURL_URL:   ${CURL_URL}"

    echo -e '\n-------------------------\n'
fi

CURL_CMD="curl \"${CURL_URL}\"
  --request ${CURL_REQUEST}
  ${CURL_VERBOSE}
  --write-out 'HTTPSTATUS:%{http_code}'
  --silent
  --header \"authorization: Bearer ${DOCUSIGN_ACCESS_TOKEN}\"
  --header \"cache-control: no-cache\"
  --header \"content-type: application/json\"
  --header \"Accept: application/json\"
  --data '{\"Name\": \"${FOLDER_NAME}\", \"ParentFolder\": {\"Href\": ${PARENT_CURL_HREF}}}'
"

source ../../../shared/curl/curl_http_response.sh
