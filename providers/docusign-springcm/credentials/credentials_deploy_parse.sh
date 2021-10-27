#!/usr/bin/env bash

# HQTEST

HQTEST_CLIENT_ID=`cat ../credentials/config/credentials.deploy.json | jq '.hqtest.client_id'`
HQTEST_REDIRECT_URI=`cat ../credentials/config/credentials.deploy.json | jq '.hqtest.redirect_uri'`
HQTEST_AUTH_URL=`cat ../credentials/config/credentials.deploy.json | jq '.hqtest.auth_url'`

HQTEST_CLIENT_ID=`echo ${HQTEST_CLIENT_ID} | tr -d \"`
HQTEST_REDIRECT_URI=`echo ${HQTEST_REDIRECT_URI} | tr -d \"`
HQTEST_AUTH_URL=`echo ${HQTEST_AUTH_URL} | tr -d \"`

# STAGE

STAGE_CLIENT_ID=`cat ../credentials/config/credentials.deploy.json | jq '.stage.client_id'`
STAGE_REDIRECT_URI=`cat ../credentials/config/credentials.deploy.json | jq '.stage.redirect_uri'`
STAGE_AUTH_URL=`cat ../credentials/config/credentials.deploy.json | jq '.stage.auth_url'`

STAGE_CLIENT_ID=`echo ${STAGE_CLIENT_ID} | tr -d \"`
STAGE_REDIRECT_URI=`echo ${STAGE_REDIRECT_URI} | tr -d \"`
STAGE_AUTH_URL=`echo ${STAGE_AUTH_URL} | tr -d \"`

# DEMO

DEMO_CLIENT_ID=`cat ../credentials/config/credentials.deploy.json | jq '.demo.client_id'`
DEMO_REDIRECT_URI=`cat ../credentials/config/credentials.deploy.json | jq '.demo.redirect_uri'`
DEMO_AUTH_URL=`cat ../credentials/config/credentials.deploy.json | jq '.demo.auth_url'`

DEMO_CLIENT_ID=`echo ${DEMO_CLIENT_ID} | tr -d \"`
DEMO_REDIRECT_URI=`echo ${DEMO_REDIRECT_URI} | tr -d \"`
DEMO_AUTH_URL=`echo ${DEMO_AUTH_URL} | tr -d \"`

# PROD

PROD_CLIENT_ID=`cat ../credentials/config/credentials.deploy.json | jq '.prod.client_id'`
PROD_REDIRECT_URI=`cat ../credentials/config/credentials.deploy.json | jq '.prod.redirect_uri'`
PROD_AUTH_URL=`cat ../credentials/config/credentials.deploy.json | jq '.prod.auth_url'`

PROD_CLIENT_ID=`echo ${PROD_CLIENT_ID} | tr -d \"`
PROD_REDIRECT_URI=`echo ${PROD_REDIRECT_URI} | tr -d \"`
PROD_AUTH_URL=`echo ${PROD_AUTH_URL} | tr -d \"`

# Display configuration values if verbose requested

if [ ${VERBOSE} = true ]
  then
    echo -e '\n-------------------------\n'

    echo "  HQTEST_CLIENT_ID:       ${HQTEST_CLIENT_ID}"
    echo "  HQTEST_REDIRECT_URI:    ${HQTEST_REDIRECT_URI}"
    echo "  HQTEST_AUTH_URL:        ${HQTEST_AUTH_URL}"
    echo -e ""
    echo "  STAGE_CLIENT_ID:        ${STAGE_CLIENT_ID}"
    echo "  STAGE_REDIRECT_URI:     ${STAGE_REDIRECT_URI}"
    echo "  STAGE_AUTH_URL:         ${STAGE_AUTH_URL}"
    echo -e ""
    echo "  DEMO_CLIENT_ID:         ${DEMO_CLIENT_ID}"
    echo "  DEMO_REDIRECT_URI:      ${DEMO_REDIRECT_URI}"
    echo "  DEMO_AUTH_URL:          ${DEMO_AUTH_URL}"
    echo -e ""
    echo "  PROD_CLIENT_ID:         ${PROD_CLIENT_ID}"
    echo "  PROD_REDIRECT_URI:      ${PROD_REDIRECT_URI}"
    echo "  PROD_AUTH_URL:          ${PROD_AUTH_URL}"

    echo -e '\n-------------------------\n'
fi
