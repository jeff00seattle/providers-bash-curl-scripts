#!/usr/bin/env bash
USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
--account\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hv --long help,verbose,account: -n 'get_docusign_account.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi

echo "$OPTS"
eval set -- "$OPTS"

HELP=false
VERBOSE=false
ACCOUNT_ID=""

# extract options and their arguments into variables.
while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true; shift ;;
    --account )         ACCOUNT_ID=$2 ; shift; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

source ../credentials/credentials_docusign_parse.sh
source ../credentials/credentials_docusign_token_parse.sh
source ../credentials/credentials_docusign_userinfo_parse.sh

if [ -n "$ACCOUNT_ID" ]
  then
    DOCUSIGN_ACCOUNT_ID=$ACCOUNT_ID
fi

source ./curl/curl_get_docusign_account_folders.sh
source ../../../shared/curl/curl_response.sh

echo "${HTTP_BODY}" |
    jq '.'

echo -e '\n-------------------------\n'