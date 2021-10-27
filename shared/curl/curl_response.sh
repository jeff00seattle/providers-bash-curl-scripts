#!/usr/bin/env bash

echo -e '\n-------------------------\n'

if [[ ${HTTP_STATUS} -lt 200  ]] || [[ ${HTTP_STATUS} -gt 399  ]]
  then
    echo "Error [HTTP status: ${HTTP_STATUS}]"
    echo "$HTTP_BODY" | jq '.'
    echo -e '\n-------------------------\n'
    exit 1
fi

echo "Success [HTTP status: ${HTTP_STATUS}]"
