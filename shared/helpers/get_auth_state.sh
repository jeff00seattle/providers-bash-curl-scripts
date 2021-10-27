#!/usr/bin/env bash

source ../../../shared/helpers/url_encode.sh
source ../../../shared/helpers/url_decode.sh

PROVIDER="ACT Archive Provider"
EXPIRY_EPOCH_SECONDS=$(eval date +%s)
DOCUSIGN_ACCOUNT_ID=$((1 + RANDOM % 100000))
DOCUSIGN_ACCOUNT_ID_GUID=$(uuidgen)

JSON_STRING=$( jq -n \
                  --arg pr "${PROVIDER}" \
                  --arg sn "${PROVIDER} Site Name" \
                  --arg aid "${DOCUSIGN_ACCOUNT_ID}" \
                  --arg aidg "${DOCUSIGN_ACCOUNT_ID_GUID}" \
                  --arg ees "${EXPIRY_EPOCH_SECONDS}" \
                  '{provider: $pr, siteName: $sn, accountId: $aid, accountIdGuid: $aidg, expiryEpochSeconds: $ees}' )



AUTH_STATE=$(echo ${JSON_STRING} | openssl enc -base64 -A)
AUTH_STATE=`url_encode "${AUTH_STATE}"`
AUTH_STATE_LENGTH=${#AUTH_STATE}
AUTH_STATE_DEC=`url_decode "${AUTH_STATE}"`
AUTH_STATE_DEC=$(echo ${AUTH_STATE_DEC} | openssl enc -base64 -d -A)

if [ ${VERBOSE} = true ]
  then
    echo -e '\n-------------------------\n'

    echo "  AUTH_STATE_DEC:     ${AUTH_STATE_DEC}"
    echo "  AUTH_STATE:         ${AUTH_STATE}"
    echo "  AUTH_STATE_LENGTH:  ${AUTH_STATE_LENGTH}"

    echo -e '\n-------------------------\n'
fi

