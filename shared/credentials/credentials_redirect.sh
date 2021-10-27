#!/usr/bin/env bash

REDIRECT_URI_DEV=`cat ../../../shared/credentials/config/credentials.redirect.json | jq '.dev.redirect_uri'`
REDIRECT_URI_RADMIN=`cat ../../../shared/credentials/config/credentials.redirect.json | jq '.radmin.redirect_uri'`
REDIRECT_URI_HQTEST=`cat ../../../shared/credentials/config/credentials.redirect.json | jq '.hqtest.redirect_uri'`
REDIRECT_URI_STAGE=`cat ../../../shared/credentials/config/credentials.redirect.json | jq '.stage.redirect_uri'`
REDIRECT_URI_DEMO=`cat ../../../shared/credentials/config/credentials.redirect.json | jq '.demo.redirect_uri'`
REDIRECT_URI_PROD=`cat ../../../shared/credentials/config/credentials.redirect.json | jq '.prod.redirect_uri'`

case ${ACCOUNT_ENV} in
  DEV)
    REDIRECT_URI=$(echo $(eval echo ${REDIRECT_URI_DEV} | tr -d \"))
    ;;
  RADMIN)
    REDIRECT_URI=$(echo $(eval echo ${REDIRECT_URI_RADMIN} | tr -d \"))
    ;;
  HQTEST)
    REDIRECT_URI=$(echo $(eval echo ${REDIRECT_URI_HQTEST} | tr -d \"))
    ;;
  STAGE)
    REDIRECT_URI=$(echo $(eval echo ${REDIRECT_URI_STAGE} | tr -d \"))
    ;;
  DEMO)
    REDIRECT_URI=$(echo $(eval echo ${REDIRECT_URI_DEMO} | tr -d \"))
    ;;
  PROD)
    REDIRECT_URI=$(echo $(eval echo ${REDIRECT_URI_PROD} | tr -d \"))
    ;;
  *)
    REDIRECT_URI=$(echo $(eval echo ${REDIRECT_URI_DEV} | tr -d \"))
    ;;
esac

if [ ${VERBOSE} = true ]
  then
    echo -e '\n-------------------------\n'

    echo "  ACCOUNT_ENV:    ${ACCOUNT_ENV}"
    echo "  REDIRECT_URI:   ${REDIRECT_URI}"

    echo -e '\n-------------------------\n'
fi