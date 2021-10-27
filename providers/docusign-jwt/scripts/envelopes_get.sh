#!/usr/bin/env bash

# https://developers.docusign.com/docs/esign-rest-api/how-to/request-signature-template-remote/

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
[--env HQTEST, STAGE, DEMO, PROD]\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hv --long help,verbose,env: -n 'envelopes_get.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi
eval set -- "$OPTS"

HELP=false
VERBOSE=false
ACCOUNT_ENV=""
ENVELOPE_ID=""

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
echo "Get the envelope request to DocuSign..."
echo "Results:"
echo ""

ESIGN_API_ENVELOPES_URL="${ESIGN_API_URL}/${ESIGN_API_VERSION}/accounts/${ACCOUNT_ID}/envelopes"

# Create the envelope request
# temp files:
response=$(mktemp /tmp/response-eg-009.XXXXXX)

echo ""
echo "Sending the envelope request to DocuSign..."

curl --header "Authorization: Bearer ${ACCESS_TOKEN}" \
     --header "Content-Type: application/json" \
     --request GET ${ESIGN_API_ENVELOPES_URL} \
     --output ${response} \
     --verbose

echo ""
cat $response | jq
