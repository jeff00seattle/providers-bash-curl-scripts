#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
[-p|--parse]\n
[--parent <string>]\n
[--file <string>]\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hvp --long help,verbose,parse,parent:,file: -n 'post_upload_file.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi
eval set -- "$OPTS"

HELP=false
VERBOSE=false
PARSE=false

PARENT="root"
FILE_PATH=""

# extract options and their arguments into variables.
while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true; shift ;;
    -p | --parse )      PARSE=true; shift ;;
    --parent)           PARENT="$2" ; shift; shift ;;
    --file)        		FILE_PATH="$2" ; shift; shift ;;
    --file-mime-type)   FILE_MIME_TYPE="$2" ; shift; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

source ../../../shared/credentials/credentials_token_parse.sh

PROTOCOL="https"
HOSTNAME="www.googleapis.com"
API_VERSION="v3"
PATHNAME="upload/drive/${API_VERSION}/files?uploadType=multipart"

source ./curl/curl_post_upload_file.sh
source ../../../shared/curl/curl_response.sh

if [ ${PARSE} = true ]
  then
     echo "${HTTP_BODY}" |
        jq '.'
else
     echo "${HTTP_BODY}" |
        jq '.'
fi

echo -e '\n-------------------------\n'
