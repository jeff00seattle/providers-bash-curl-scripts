#!/usr/bin/env bash

# https://developers.docusign.com/docs/esign-rest-api/how-to/request-signature-template-remote/

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
[--env HQTEST, STAGE, DEMO, PROD]\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hv --long help,verbose,env: -n 'envelope_template_post.sh' -- "$@"`
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
response=$(mktemp /tmp/response-eg-011.XXXXXX)

echo ""
echo "Sending the envelope request to DocuSign..."
echo "Results:"
echo ""

CURL_URL="${ESIGN_API_URL}/${ESIGN_API_VERSION}/accounts/${ACCOUNT_ID}/envelopes"
CC_EMAIL="${ACCOUNT_EMAIL}"
CC_NAME="${ACCOUNT_NAME}"
SIGNER_EMAIL="${ACCOUNT_EMAIL}"
SIGNER_NAME="${ACCOUNT_NAME}"

# Create the envelope request
# temp files:
response=$(mktemp /tmp/response-eg-009.XXXXXX)

if [ ${VERBOSE} = true ]
  then
    echo -e '\n-------------------------\n'

    echo "  CURL_URL:           ${CURL_URL}"
    echo "  CC_EMAIL:           ${CC_EMAIL}"
    echo "  CC_NAME:            ${CC_NAME}"
    echo "  SIGNER_EMAIL:       ${SIGNER_EMAIL}"
    echo "  SIGNER_NAME:        ${SIGNER_NAME}"
    echo "  TEMPLATE_ID:        ${TEMPLATE_ID}"
    echo "  ACCOUNT_ID:         ${ACCOUNT_ID}"

    echo -e '\n-------------------------\n'
fi

echo ""
echo "Sending the envelope request to DocuSign..."

curl --header "Authorization: Bearer ${ACCESS_TOKEN}" \
     --header "Content-Type: application/json" \
     --data-binary \
"{
    \"templateId\": \"${TEMPLATE_ID}\",
    \"templateRoles\": [
        {
            \"email\": \"${SIGNER_EMAIL}\",
            \"name\": \"${SIGNER_NAME}\",
            \"roleName\": \"signer\"
        },
        {
            \"email\": \"${CC_EMAIL}\",
            \"name\": \"${CC_NAME}\",
            \"roleName\": \"cc\"
        }
    ],
    \"status\": \"sent\"
}" \
     --request POST ${CURL_URL} \
     --output ${response} \
     --verbose

echo ""
cat $response | jq

