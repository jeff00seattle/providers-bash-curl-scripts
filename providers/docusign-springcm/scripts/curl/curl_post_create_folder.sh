#!/usr/bin/env bash

CURL_REQUEST="POST"

if [ -z "${ACCESS_TOKEN}" ]
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

CURL_CMD="curl \"${API_BASE_URL}/${API_VERSION}/folders\"
  --request ${CURL_REQUEST}
  ${CURL_VERBOSE}
  --write-out 'HTTPSTATUS:%{http_code}'
  --silent
  --header \"authorization: Bearer ${ACCESS_TOKEN}\"
  --header \"cache-control: no-cache\"
  --header \"content-type: application/json\"
  --header \"Accept: application/json\"
  --data '{\"Name\": \"${FOLDER_NAME}\", \"ParentFolder\": {\"Href\": ${PARENT_CURL_HREF}}}'
"

source ../../../shared/curl/curl_http_response.sh
