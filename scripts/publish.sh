#!/usr/bin/env bash

git pull origin master
git add --all .
git commit -m "$1"
git push origin master
