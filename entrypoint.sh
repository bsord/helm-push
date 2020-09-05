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

if [ -z "$FORCE" ]; then
  FORCE=""
elif [ "$FORCE" == "1" ] || [ "$FORCE" == "True" ] || [ "$FORCE" == "TRUE" ] || [ "$FORCE" == "true" ]; then
  FORCE="-f"
fi

if [ -z "$CHARTMUSEUM_ACCESS_TOKEN" ] && [ [ -z "$CHARTMUSEUM_USERNAME" ] || [ -z "$CHARTMUSEUM_PASSWORD" ] ]
  echo "Credentials are required, but none defined."
  exit 1
fi

if [ "$CHARTMUSEUM_ACCESS_TOKEN" ]; then
  echo "Access token is defined, using bearer auth."
  helm inspect chart .
  helm lint .
  helm repo add chart-repo ${CHARTMUSEUM_URL}
  helm push . chart-repo --access-token ${CHARTMUSEUM_ACCESS_TOKEN} ${FORCE}
fi

if [ -z "$CHARTMUSEUM_ACCESS_TOKEN" ]; then
  echo "Access token is not defined, using basic auth."

  if [ -z "$CHARTMUSEUM_USERNAME" ]; then
    echo "Username is required but not defined."
    exit 1
  fi

  if [ -z "$CHARTMUSEUM_PASSWORD" ]; then
    echo "Password is required but not defined."
    exit 1
  fi

  helm inspect chart .
  helm lint .
  helm push . ${CHARTMUSEUM_URL} --username ${CHARTMUSEUM_USERNAME} --password ${CHARTMUSEUM_PASSWORD} ${FORCE}
  
fi

cd ${CHART_FOLDER}

helm inspect chart .
helm lint .
helm push . ${CHARTMUSEUM_URL} --access-token ${CHARTMUSEUM_ACCESS_TOKEN} ${FORCE}