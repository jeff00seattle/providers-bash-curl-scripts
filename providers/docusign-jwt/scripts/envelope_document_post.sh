#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
[--env HQTEST, STAGE, DEMO, PROD]\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hv --long help,verbose,env: -n 'envelope_document_post.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi
eval set -- "$OPTS"

HELP=false
VERBOSE=false
ACCOUNT_ENV=""

while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true; shift ;;
    --env )             ACCOUNT_ENV="$2" ; shift; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

source ../credentials/credentials_docusign_parse.sh
source ../../../shared/helpers/url_parse_query_string.sh
source ../../../shared/credentials/credentials_token_parse.sh

if [ -z "${ACCESS_TOKEN}" ]
  then
    echo "Missing ACCESS_TOKEN"; exit 1
fi

# temp files:
request_data=$(mktemp /tmp/request-eg-011.XXXXXX)
response=$(mktemp /tmp/response-eg-011.XXXXXX)
doc1_base64=$(mktemp /tmp/eg-011-doc1.XXXXXX)

# Fetch docs and encode
cat ../demo_documents/World_Wide_Corp_lorem.pdf | base64 > $doc1_base64

echo ""
echo "Sending the envelope request to DocuSign..."
echo "Results:"
echo ""

CURL_URL="${ESIGN_API_URL}/${ESIGN_API_VERSION}/accounts/${ACCOUNT_ID}/envelopes"
CC_EMAIL="${ACCOUNT_EMAIL}"
CC_NAME="${ACCOUNT_NAME}"

if [ ${VERBOSE} = true ]
  then
    echo -e '\n-------------------------\n'

    echo "  CURL_URL:           ${CURL_URL}"
    echo "  CC_EMAIL:           ${CC_EMAIL}"
    echo "  CC_NAME:            ${CC_NAME}"
    echo "  ACCOUNT_ID:         ${ACCOUNT_ID}"

    echo -e '\n-------------------------\n'
fi

# Concatenate the different parts of the request
printf \
'{
    "emailSubject": "Please sign this document",
    "documents": [
        {
            "documentBase64": "' >> $request_data
            cat $doc1_base64 >> $request_data
            printf '",
            "name": "World Wide Corp",
            "fileExtension": "pdf", "documentId": "1"
        }
    ],
    "recipients": {
        "carbonCopies": [
            {
                "email": "'${CC_EMAIL}'", "name": "'"${CC_NAME}"'",
                "recipientId": "1", "routingOrder": "1"
            }
        ]
    },
    "status": "created"
}' >> $request_data


curl --header "Authorization: Bearer ${ACCESS_TOKEN}" \
     --header "Content-Type: application/json" \
     --data-binary @${request_data} \
     --request POST ${CURL_URL} \
     --output $response \
     --write-out 'HTTPSTATUS:%{http_code}' \
     --verbose

echo ""
cat $response | jq
