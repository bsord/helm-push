#!/bin/bash
set -e

if [ -z "$CHART_FOLDER" ]; then
  echo "Chart folder is required but not defined."
  exit 1
fi

if [ -z "$CHARTMUSEUM_URL" ]; then
  echo "Repository url is required but not defined."
  exit 1
fi

if [ -z "$CHARTMUSEUM_ACCESS_TOKEN" ] && [ [ -z "$CHARTMUSEUM_USERNAME" ] -o [ -z "$CHARTMUSEUM_PASSWORD" ] ]; then
  echo "Credentials are required, but none defined."
  exit 1
fi

if [ "$FORCE" == "1" ] || [ "$FORCE" == "True" ] || [ "$FORCE" == "TRUE" ] || [ "$FORCE" == "true" ]; then
  FORCE="-f"
else
  FORCE=""
fi

if [ "$CHARTMUSEUM_ACCESS_TOKEN" ]; then
  echo "Access token is defined, using bearer auth."
  CHARTMUSEUM_ACCESS_TOKEN="--access-token ${CHARTMUSEUM_ACCESS_TOKEN}"
fi


if [ "$CHARTMUSEUM_USERNAME" ]; then
  echo "Username is defined, using as parameter."
  CHARTMUSEUM_USERNAME="--username ${CHARTMUSEUM_USERNAME}"
fi

if [ "$CHARTMUSEUM_PASSWORD" ]; then
  echo "Password is defined, using as parameter."
  CHARTMUSEUM_PASSWORD="--password ${CHARTMUSEUM_PASSWORD}"
fi

if [ "$CHARTMUSEUM_VERSION" ]; then
  echo "Version is defined, using as parameter."
  CHARTMUSEUM_VERSION="--version ${CHARTMUSEUM_VERSION}"
fi

if [ "$CHARTMUSEUM_APPVERSION" ]; then
  echo "Version is defined, using as parameter."
  CHARTMUSEUM_APPVERSION="--app-version ${CHARTMUSEUM_APPVERSION}"
fi

cd ${CHART_FOLDER}
helm repo add stable https://charts.helm.sh/stable
helm repo update
helm lint .
helm package . ${CHARTMUSEUM_APPVERSION} ${CHARTMUSEUM_VERSION}
helm inspect chart *.tgz
helm push *.tgz ${CHARTMUSEUM_URL} ${CHARTMUSEUM_USERNAME} ${CHARTMUSEUM_PASSWORD} ${CHARTMUSEUM_ACCESS_TOKEN} ${FORCE}