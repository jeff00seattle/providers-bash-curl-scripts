#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
[-p|--parse]\n
[--folder <string>]\n
[--parent <string>]\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hvp --long help,verbose,parse,folder:,parent: -n 'list_all.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi

# echo "$OPTS"
eval set -- "$OPTS"

HELP=false
VERBOSE=false
PARSE=false

FOLDER=""
PARENT="0"

while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true; shift ;;
    -p | --parse )      PARSE=true; shift ;;
    --folder )          FOLDER="$2" ; shift; shift ;;
    --parent )          PARENT="$2" ; shift; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

source ../credentials/credentials_parse.sh
source ../../../shared/credentials/credentials_token_parse.sh

PATHNAME="${API_VERSION}/search?query=${FOLDER}&type=folder&ancestor_folder_ids=${PARENT}&trash_content=non_trashed_only"
QUERY="fields=id,name,type,item_collection,modified_at"

source ./curl/curl_get_search_folders_by_name.sh
source ../../../shared/curl/curl_response.sh

if [ ${PARSE} = true ]
  then
	echo "${HTTP_BODY}" |
	    jq '.entries |
	    map({type, name, id})'
else
     echo "${HTTP_BODY}" |
        jq '.'
fi

echo -e '\n-------------------------\n'
