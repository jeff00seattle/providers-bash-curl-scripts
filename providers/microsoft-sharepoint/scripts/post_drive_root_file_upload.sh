#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
--file <string>\n
--drive <string>\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hv --long help,verbose,file:,drive: -n 'post_drive_root_file_upload.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi

echo "$OPTS"
eval set -- "$OPTS"

HELP=false
VERBOSE=false

FILE_PATH=""
DRIVE_ID=""

# extract options and their arguments into variables.
while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true; shift ;;
    --file )            FILE_PATH="$2" ; shift; shift ;;
    --drive )           DRIVE_ID=$2 ; shift; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

if [ -z "${FILE_PATH}" ]
  then
    echo "Provide --file" ; usage ; exit 1
fi

if [ -z "$DRIVE_ID" ]
  then
    echo "Provide --drive" ; usage ; exit 1
fi

source ../../../shared/credentials/credentials_token_parse.sh

FILE_BASENAME=$(echo ${FILE_PATH##*/})
FILE_MEME_TYPE=$(echo $(file -b --mime-type ${FILE_PATH}))

echo "  FILE_BASENAME: $FILE_BASENAME"
echo "  FILE_MEME_TYPE: ${FILE_MEME_TYPE}"

CURL_REQUEST="POST"
PROTOCOL="https"
HOSTNAME="graph.microsoft.com"
API_VERSION="v1.0"
PATHNAME="${API_VERSION}/drives/${DRIVE_ID}/root:/${FILE_BASENAME}:/content"

source ./curl/curl_post_drive_file_upload.sh
source ../../../shared/curl/curl_response.sh

echo "${HTTP_BODY}" |
    jq '.'

echo -e '\n-------------------------\n'
