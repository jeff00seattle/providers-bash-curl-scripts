#!/usr/bin/env bash

if [ ${VERBOSE} = true ]
  then
    echo -e '\n-------------------------\n'

    echo "  ARG_CLIENT_ID:          ${ARG_CLIENT_ID}"
    echo "  ARG_CLIENT_SECRET:      ${ARG_CLIENT_SECRET}"

    echo -e '\n-------------------------\n'
fi

cat ../credentials/config/credentials.docusign.json | jq '.client_id = $v' --arg v ${ARG_CLIENT_ID} | sponge ../credentials/config/credentials.docusign.json
cat ../credentials/config/credentials.docusign.json | jq '.client_secret = $v' --arg v ${ARG_CLIENT_SECRET} | sponge ../credentials/config/credentials.docusign.json
