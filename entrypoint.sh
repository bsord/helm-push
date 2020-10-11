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

if [ -z "$FORCE" ]; then
  FORCE=""
elif [ "$FORCE" == "1" ] || [ "$FORCE" == "True" ] || [ "$FORCE" == "TRUE" ] || [ "$FORCE" == "true" ]; then
  FORCE="-f"
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
  CHARTMUSEUM_VERSION="--password ${CHARTMUSEUM_VERSION}"
fi

cd ${CHART_FOLDER}
helm inspect chart .
helm lint .
helm push . ${CHARTMUSEUM_URL} ${CHARTMUSEUM_USERNAME} ${CHARTMUSEUM_PASSWORD} ${CHARTMUSEUM_ACCESS_TOKEN} ${CHARTMUSEUM_VERSION} ${FORCE}
  
