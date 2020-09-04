#!/bin/sh -l
helm plugin install https://github.com/chartmuseum/helm-push

helm repo add default-repo $2
helm push ./chart default-repo --access-token $1
ls
cat ~/.cfconfig
echo "Hello $1 $2"
time=$(date)
echo "::set-output name=time::$time"
