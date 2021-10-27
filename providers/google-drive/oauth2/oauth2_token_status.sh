#!/usr/bin/env bash

source ../credentials/credentials_parse.sh
source ../../../shared/credentials/credentials_token_parse.sh

#4) get status of token
# -G, --get           Put the post data in the URL and use GET
# -L, --location      Follow redirects
# -S, --show-error    Show error even when -s is used
# -s, --silent        Silent mode

CURL_CMD="curl -SLG \"${AUTH_TOKEN_INFO_URL}\"
  --data-urlencode \"access_token=${ACCESS_TOKEN}\"
  --request GET
  --verbose
  --connect-timeout 60
"

echo "  CURL_CMD: ${CURL_CMD}"
CURL_RESPONSE=$(eval $CURL_CMD)

echo $CURL_RESPONSE | jq .