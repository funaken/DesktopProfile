#!/bin/sh

if [[ $# != 1 ]]; then
  echo "Usage: $0 gist-url"
  exit 1
fi

if [ -e tmp.diff ]; then
  echo "tmp.diff already exists"
  exit 1
fi

export URL=$1

read -p "Are you sure to apply patch? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

curl ${URL} -o tmp.diff

git apply --whitespace=warn tmp.diff

rm tmp.diff
