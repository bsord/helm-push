#!/bin/sh -l
codefresh auth create-context --api-key $1
ls
echo "Hello $1"
time=$(date)
echo "::set-output name=time::$time"