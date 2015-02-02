#!/bin/bash

# Build New Image
docker build -t bvallelunga/enjoypnd .

# Run New Images
if [ -z "$1" ]; then
  docker run -p 3000:3000 -d bvallelunga/enjoypnd
else
  for i in $(echo $1 | tr "," "\n"); do
    if [ "$i" == "dev" ] || [ "$i" == "both" ]; then
      docker run -p 3000:3000 -d bvallelunga/enjoypnd
    fi

    if [ "$i" == "prod" ] || [ "$i" == "both" ]; then
      docker run -p 80:3000 -d -e NODE_ENV=production bvallelunga/enjoypnd

    elif [ "$i" != "dev" ]; then
      docker run -p $i:3000 -d bvallelunga/enjoypnd
    fi
  done
fi
