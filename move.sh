#!/bin/bash

# 
#    Move a lmod installation from one base directory to another
#

src=$1
dst=$2


# Fetch the first line of the file to get the old path to lua
oldluapath=$(cat $src/lmod/lmod/libexec/addto | head -n 1)
luapath="modules/lua/v5.4.3/noarch/lua"

fragsize=${#luapath}
pathsize=${#oldluapath}
n=$(($pathsize - $fragsize))
oldpath=${oldluapath:2:n}


echo "Inferred base: $oldpath"
echo "    Moving to: $dst"

newluapath="#!$dst/$luapath"

echo "Copy"
# Copy
cp -R $src $dst

echo "Update paths"
# all files and replace the old path by the new
find $COOKIED -type f -print0 | xargs -0 sed -i -e "s/$oldluapath/$newluapath/g"
