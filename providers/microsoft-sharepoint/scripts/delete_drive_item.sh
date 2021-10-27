#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
--drive <string>\n
--item <string>\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hv --long help,verbose,drive:,item: -n 'delete_drive_item.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi

echo "$OPTS"
eval set -- "$OPTS"

HELP=false
VERBOSE=false
PARSE=false
DRIVE_ID=""
ITEM_ID=""

# extract options and their arguments into variables.
while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true; shift ;;
    --item )            ITEM_ID="$2" ; shift; shift ;;
    --drive )           DRIVE_ID=$2 ; shift; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

if [ -z "$ITEM_ID" ]
  then
    echo "Provide --item" ; usage ; exit 1
fi

if [ -z "$DRIVE_ID" ]
  then
    echo "Provide --drive" ; usage ; exit 1
fi

source ../../../shared/credentials/credentials_token_parse.sh

PROTOCOL="https"
HOSTNAME="graph.microsoft.com"
API_VERSION="v1.0"
PATHNAME="${API_VERSION}/drives/${DRIVE_ID}/items/${ITEM_ID}"
CURL_REQUEST="DELETE"

source ./curl/curl_delete_drive_item.sh
source ../../../shared/curl/curl_response.sh

echo "${HTTP_BODY}" |
  jq '.'



echo -e '\n-------------------------\n'
