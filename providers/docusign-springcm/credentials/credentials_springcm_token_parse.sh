#!/usr/bin/env bash

source ../../../shared/helpers/url_parse.sh

ACCESS_TOKEN=`cat ../credentials/config/credentials.token.json | jq '.access_token'`
TOKEN_TYPE=`cat ../credentials/config/credentials.token.json | jq '.token_type'`./
EXPIRES_IN=`cat ../credentials/config/credentials.token.json | jq '.expires_in'`
REFRESH_TOKEN=`cat ../credentials/config/credentials.token.json | jq '.refresh_token'`
API_BASE_URL=`cat ../credentials/config/credentials.token.json | jq '.api_base_url'`

ACCESS_TOKEN=`echo ${ACCESS_TOKEN} | tr -d \"`
REFRESH_TOKEN=`echo ${REFRESH_TOKEN} | tr -d \"`
TOKEN_TYPE=`echo ${TOKEN_TYPE} | tr -d \"`
API_BASE_URL=$(echo $(eval echo ${API_BASE_URL} | tr -d \"))

# extract the PROTOCOL
URL_PROTOCOL=$(echo ${API_BASE_URL} | grep :// | sed -e's,^\(.*://\).*,\1,g')

# extract the PROTOCOL SCHEME
URL_SCHEME=$(echo ${URL_PROTOCOL::-3})
#echo "  URL_SCHEME:         ${URL_SCHEME}"

URL_DOMAIN=$(echo ${API_BASE_URL} | sed -e s,${URL_PROTOCOL},,g)
#echo "  URL_DOMAIN:         ${URL_DOMAIN}"

URL_SUB_DOMAIN=$(echo ${URL_DOMAIN} | cut -d'.' -f1)
URL_SECOND_DOMAIN=$(echo ${URL_DOMAIN} | cut -d'.' -f2)
URL_TOP_DOMAIN=$(echo ${URL_DOMAIN} | cut -d'.' -f3)
API_DOMAIN=$(echo ${URL_SECOND_DOMAIN}.${URL_TOP_DOMAIN})

API_DATA_CENTER=$(echo ${URL_SUB_DOMAIN} | cut -c 4-)
#echo "  API_DATA_CENTER:    ${API_DATA_CENTER}"

API_UPLOAD_URL=$(echo "${URL_PROTOCOL}://apiupload${API_DATA_CENTER}.${API_DOMAIN}")

if [ ${VERBOSE} = true ]
  then
    echo "  ACCESS_TOKEN:       ${ACCESS_TOKEN}"
    echo "  TOKEN_TYPE:         ${TOKEN_TYPE}"
    echo "  EXPIRES_IN:         ${EXPIRES_IN}"
    echo "  REFRESH_TOKEN:      ${REFRESH_TOKEN}"

    echo "  API_DATA_CENTER:    ${API_DATA_CENTER}"
    echo "  API_BASE_URL:       ${API_BASE_URL}"
    echo "  API_UPLOAD_URL:     ${API_UPLOAD_URL}"
fi