#!/bin/bash
set -e

if [ -z "$CHART_FOLDER" ]; then
  echo "Chart folder is required but not defined."
  exit 1
fi

if [ -z "$REGISTRY_URL" ]; then
  echo "Repository url is required but not defined."
  exit 1
fi

if [ -z "$REGISTRY_ACCESS_TOKEN" ]; then
  if [ -z "$REGISTRY_USERNAME" ] || [ -z "$REGISTRY_PASSWORD" ]; then
    echo "Credentials are required, but none defined."
    exit 1
  fi
fi

if [ "$FORCE" == "1" ] || [ "$FORCE" == "True" ] || [ "$FORCE" == "TRUE" ] || [ "$FORCE" == "true" ]; then
  FORCE="-f"
else
  FORCE=""
fi

if [ "$UPDATE_DEPENDENCIES" == "1" ] || [[ "$UPDATE_DEPENDENCIES" == [Tt][Rr][Uu][Ee] ]]; then
  UPDATE_DEPENDENCIES="-u"
else
  UPDATE_DEPENDENCIES=""
fi

if [ "$REGISTRY_VERSION" ]; then
  echo "Version is defined, using as parameter."
  REGISTRY_VERSION="--version ${REGISTRY_VERSION}"
fi

if [ "$REGISTRY_APPVERSION" ]; then
  echo "App version is defined, using as parameter."
  REGISTRY_APPVERSION="--app-version ${REGISTRY_APPVERSION}"
fi

if [ "$USE_OCI_REGISTRY" == "TRUE" ] || [ "$USE_OCI_REGISTRY" == "true" ]; then
  export HELM_EXPERIMENTAL_OCI=1
  echo "OCI SPECIFIED, USING HELM OCI FEATURES"
  REGISTRY=$(echo "${REGISTRY_URL}" | awk -F[/:] '{print $4}') # Get registry host from url
  echo "${REGISTRY_ACCESS_TOKEN}" | helm registry login -u ${REGISTRY_USERNAME} --password-stdin ${REGISTRY} # Authenticate registry
  echo "Packaging chart '$CHART_FOLDER'"
  PKG_RESPONSE=$(helm package ${CHART_FOLDER} ${REGISTRY_VERSION} ${REGISTRY_APPVERSION} ${UPDATE_DEPENDENCIES}) # package chart
  echo "$PKG_RESPONSE"
  CHART_TAR_GZ=$(basename "$PKG_RESPONSE") # extract tar name from helm package stdout
  echo "Pushing chart $CHART_TAR_GZ to '$REGISTRY_URL'"
  helm push "$CHART_TAR_GZ" "$REGISTRY_URL"
  echo "Successfully pushed chart $CHART_TAR_GZ to '$REGISTRY_URL'"
  exit 0
fi

if [ "$REGISTRY_ACCESS_TOKEN" ]; then
  echo "Access token is defined, using bearer auth."
  REGISTRY_ACCESS_TOKEN="--access-token ${REGISTRY_ACCESS_TOKEN}"
fi


if [ "$REGISTRY_USERNAME" ]; then
  echo "Username is defined, using as parameter."
  REGISTRY_USERNAME="--username ${REGISTRY_USERNAME}"
fi

if [ "$REGISTRY_PASSWORD" ]; then
  echo "Password is defined, using as parameter."
  REGISTRY_PASSWORD="--password ${REGISTRY_PASSWORD}"
fi

if [ "$ADD_REPOSITORIES" != "" ]; then
  while read addRepositoryArgs;
  do
    eval $(echo helm repo add $addRepositoryArgs)
  done <<< "$ADD_REPOSITORIES"
  helm repo update
fi

cd ${CHART_FOLDER}
helm lint .
helm package . ${REGISTRY_APPVERSION} ${REGISTRY_VERSION} ${UPDATE_DEPENDENCIES}
helm inspect chart *.tgz
helm cm-push *.tgz ${REGISTRY_URL} ${REGISTRY_USERNAME} ${REGISTRY_PASSWORD} ${REGISTRY_ACCESS_TOKEN} ${FORCE}
