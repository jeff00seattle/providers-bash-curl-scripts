#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
[--file <string>]\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hv --long help,verbose,file: -n 'put_user_drive_root_file_upload.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi

echo "$OPTS"
eval set -- "$OPTS"

HELP=false
VERBOSE=false

FILE_PATH=""

# extract options and their arguments into variables.
while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true; shift ;;
    --file )            FILE_PATH="$2" ; shift; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

source ../../../shared/credentials/credentials_token_parse.sh

FILE_BASENAME=$(echo ${FILE_PATH##*/})
FILE_MEME_TYPE=$(echo $(file -b --mime-type ${FILE_PATH}))

echo "  FILE_BASENAME: $FILE_BASENAME"
echo "  FILE_MEME_TYPE: ${FILE_MEME_TYPE}"

CURL_REQUEST="PUT"
PROTOCOL="https"
HOSTNAME="graph.microsoft.com"
API_VERSION="v1.0"
PATHNAME="${API_VERSION}/me/drive/root:/${FILE_BASENAME}:/content"


source ./curl/curl_put_user_drive_root_file_upload.sh
source ../../../shared/curl/curl_response.sh

echo "${HTTP_BODY}" |
    jq '.'

echo -e '\n-------------------------\n'
