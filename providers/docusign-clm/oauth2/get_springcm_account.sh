#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
[-p|--parse]\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hvp --long help,verbose,parse -n 'get_springcm_account.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi

eval set -- "$OPTS"

HELP=false
VERBOSE=false
PARSE=false

# extract options and their arguments into variables.
while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true ; shift ;;
    -p | --parse )      PARSE=true ; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

CURL_REQUEST="GET"

source ../credentials/credentials_springcm_parse.sh
source ../credentials/credentials_docusign_account_parse.sh
source ../credentials/credentials_docusign_token_parse.sh

source curl/curl_get_springcm_account.sh

source ../../../shared/curl/curl_response.sh

echo "${HTTP_BODY}" |
  jq '.'

echo -e '\n-------------------------\n'

rm -f ../credentials/config/credentials.springcm.account.json

echo "${HTTP_BODY}" |
  jq '.' > ../credentials/config/credentials.springcm.account.json
