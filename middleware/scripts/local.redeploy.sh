#!/bin/bash

# Stop & Remove Old Containers
docker stop $(docker ps -a -q) 2> /dev/null
docker rm $(docker ps -a -q) 2> /dev/null

# Remove Old Images
docker rmi bvallelunga/enjoypnd 2> /dev/null

# Build New Image
bash scripts/local.deploy.sh "$1"
