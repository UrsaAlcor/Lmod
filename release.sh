#!/bin/sh

base="https://api.github.com/repos"
owner=UrsaAlcor
repo=lua

url="$base/$owner/$repo/actions/artifacts"
access_token="$ACCESS_TOKEN_URSA"

echo $url
wget $url -O artifacts.json

jq -c ".artifacts | sort_by(.created_at) | reverse | unique_by(.name) | .[]" artifacts.json | while read i; do
    name=$(echo "$i" | jq -r -c '.name')
    archurl=$(echo "$i" | jq -r -c '.archive_download_url')

    echo "$name $archurl $access_token"
    wget --post-data="access_token=$access_token" $archurl -O $name.zip
done

