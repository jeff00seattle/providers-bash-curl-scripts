#!/usr/bin/env bash

source ../credentials/credentials_parse.sh
source ../../../shared/credentials/credentials_token_parse.sh

CURL_CMD="curl \"https://www.googleapis.com/userinfo/v2/me?access_token=${ACCESS_TOKEN}\"
  --request GET
  --verbose
  --connect-timeout 60
"

echo "  CURL_CMD: ${CURL_CMD}"
CURL_RESPONSE=$(eval $CURL_CMD)

echo -e '\n-------------------------\n'

echo $CURL_RESPONSE |
  jq '.'

echo -e '\n-------------------------\n'