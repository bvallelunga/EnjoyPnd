#!/usr/bin/env bash

git add --all .
git commit -m "$1"
git push origin master
