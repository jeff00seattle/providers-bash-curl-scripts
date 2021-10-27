#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
--folder <string>\n
--parent <string>\n
--drive <string>\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hvp --long help,verbose,folder:,parent:,drive: -n 'post_drive_parent_folder_create.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi

# echo "$OPTS"
eval set -- "$OPTS"

HELP=false
VERBOSE=false
FOLDER_NAME=""
PARENT_ID=""
DRIVE_ID=""

while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true ; shift ;;
    --folder )          FOLDER_NAME=$2 ; shift; shift ;;
    --parent )          PARENT_ID=$2 ; shift; shift ;;
    --drive )           DRIVE_ID=$2 ; shift; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

if [ -z "${FOLDER_NAME}" ]
  then
    echo "Provide --folder" ; usage ; exit 1
fi

if [ -z "${PARENT_ID}" ]
  then
    echo "Provide --parent" ; usage ; exit 1
fi

if [ -z "$DRIVE_ID" ]
  then
    echo "Provide --drive" ; usage ; exit 1
fi

source ../../../shared/credentials/credentials_token_parse.sh

CURL_REQUEST="POST"
PROTOCOL="https"
HOSTNAME="graph.microsoft.com"
API_VERSION="v1.0"
PATHNAME="${API_VERSION}/drives/${DRIVE_ID}/items/${PARENT_ID}/children"

source ./curl/curl_post_drive_folder_create.sh
source ../../../shared/curl/curl_response.sh

echo "${HTTP_BODY}" |
    jq '.'