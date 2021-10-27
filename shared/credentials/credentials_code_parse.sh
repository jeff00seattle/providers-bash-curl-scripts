#!/usr/bin/env bash

AUTHENTICATION_CODE=`cat ../credentials/config/credentials.code.json | jq '.code'`

AUTHENTICATION_CODE=`echo ${AUTHENTICATION_CODE} | tr -d \"`

if [ ${VERBOSE} = true ]
  then
    echo -e '\n-------------------------\n'

    echo "  AUTHENTICATION_CODE: ${AUTHENTICATION_CODE}"

    echo -e '\n-------------------------\n'
fi