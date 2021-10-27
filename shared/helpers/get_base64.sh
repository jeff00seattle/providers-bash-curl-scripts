#!/usr/bin/env bash

source ../../providers/docusign-clm/credentials/credentials_parse.sh

AUTHORIZATION_BASE64=$(echo "${CLIENT_ID}:${CLIENT_SECRET} | base64")