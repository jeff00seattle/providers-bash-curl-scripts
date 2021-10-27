#!/usr/bin/env bash

ACCESS_TOKEN=`cat ../credentials/config/credentials.token.json | jq '.access_token'`
REFRESH_TOKEN=`cat ../credentials/config/credentials.token.json | jq '.refresh_token'`
TOKEN_TYPE=`cat ../credentials/config/credentials.token.json | jq '.token_type'`
EXPIRES_IN=`cat ../credentials/config/credentials.token.json | jq '.expires_in'`
SCOPE=`cat ../credentials/config/credentials.token.json | jq '.scope'`

ACCESS_TOKEN=`echo ${ACCESS_TOKEN} | tr -d \"`
REFRESH_TOKEN=`echo ${REFRESH_TOKEN} | tr -d \"`
TOKEN_TYPE=`echo ${TOKEN_TYPE} | tr -d \"`

if [ ${VERBOSE} = true ]
  then
    echo -e '\n-------------------------\n'

    echo "  ACCESS_TOKEN: ${ACCESS_TOKEN}"
    echo "  REFRESH_TOKEN: ${REFRESH_TOKEN}"
    echo "  TOKEN_TYPE: ${TOKEN_TYPE}"
    echo "  EXPIRES_IN: ${EXPIRES_IN}"
    echo "  SCOPE: $SCOPE"

    echo -e '\n-------------------------\n'
fi