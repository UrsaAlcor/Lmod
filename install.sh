#!/bin/bash

# Fetch release
version=${1:-v0.0.0}
arch=${2:-x86_64}
dest=${3-/opt}

url="https://github.com/UrsaAlcor/Lmod/releases/download/$version/lmod_$arch.zip"
file=lmod_$arch.zip

wget -$url O $file

# Unzip the release to the right location
unzip $file -d $dest

## Upate paths to the new location
$dest/scripts/relocate.sh $dest

# Lua is now set
module load lua
which lua
