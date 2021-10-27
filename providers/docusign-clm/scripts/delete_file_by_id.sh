#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
[--random]\n
[--id <string>]\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hv --long help,verbose,random,id: -n 'delete_file_by_id.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi

echo "$OPTS"
eval set -- "$OPTS"

HELP=false
VERBOSE=false
PARENT_RANDOM=false
FILE_ID=""

# extract options and their arguments into variables.
while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true; shift ;;
    --random )          PARENT_RANDOM=true; shift ;;
    --id )              FILE_ID="$2" ; shift; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

if [[ ${PARENT_RANDOM} = true ]];
  then
    FILE_ID="$(uuidgen | tr '[:upper:]' '[:lower:]')"
fi

if [[ -z "${FILE_ID}" ]]
  then
    echo "Provide --id" ; usage ; exit 1
fi

source ../credentials/credentials_springcm_parse.sh
source ../credentials/credentials_docusign_account_parse.sh
source ../credentials/credentials_springcm_account_parse.sh

source ../credentials/credentials_docusign_token_parse.sh

if [ -z "${DOCUSIGN_ACCOUNT_ID}" ]
  then
    echo "Missing DOCUSIGN_ACCOUNT_ID" ; usage ; exit 1
fi

CURL_URL="${SPRINGCM_API_BASE_URL}/${SPRINGCM_API_VERSION}/${DOCUSIGN_ACCOUNT_ID}/documents/${FILE_ID}"

source ./curl/curl_delete_file_by_id.sh

source ../../../shared/curl/curl_response.sh

echo "${HTTP_BODY}" |
    jq '.'

echo -e '\n-------------------------\n'

