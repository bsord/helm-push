#!/bin/bash
set -e

if [ -z "$CHART_FOLDER" ]; then
  echo "CHART_FOLDER is not set. Quitting."
  exit 1
fi

if [ -z "$CHARTMUSEUM_URL" ]; then
  echo "CHARTMUSEUM_URL is not set. Quitting."
  exit 1
fi

if [ -z "$CHARTMUSEUM_ACCESS_TOKEN" ]; then
  echo "CHARTMUSEUM_USER is not set. Quitting."
  exit 1
fi

if [ -z "$SOURCE_DIR" ]; then
  SOURCE_DIR="."
fi

if [ -z "$FORCE" ]; then
  FORCE=""
elif [ "$FORCE" == "1" ] || [ "$FORCE" == "True" ] || [ "$FORCE" == "TRUE" ]; then
  FORCE="-f"
fi



cd ${SOURCE_DIR}/${CHART_FOLDER}

helm inspect chart .
helm lint .
helm repo add chart-repo ${CHARTMUSEUM_URL}
helm push . chart-repo --access-token ${CHARTMUSEUM_ACCESS_TOKEN} ${FORCE}