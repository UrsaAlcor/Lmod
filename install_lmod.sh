#!/bin/sh

origin=$(pwd)
base=$origin/modules

# Use noarch lua
lua_version=$(cd subprojects/lua && git describe --tags --abbrev=0)
lua=$base/lua/$lua_version/noarch/lua
luac=$base/lua/$lua_version/noarch/luac

# Setup lmod in noarch
lmod_src=$origin/subprojects/lmod
lmod_version=$(cd subprojects/lmod && git describe --tags --abbrev=0)
lmod_base=$base/lmod/$lmod_version/
lmod_config=$base/lmod/config

mkdir -p $lmod_config
mkdir -p $lmod_base

#   the `noarch` arch folder is missing :(
#   --prefix=/opt/apps => /opt/apps/lmod/X.Y
#

cd $lmod_src

./configure --prefix="$base"                    \
            --with-lua="$lua"                   \
            --with-luac="$luac"                 \
            --with-tcl=no                       \
            --with-module-root-path=$base       \
            --with-ModulePathInit=$lmod_config  \
            --with-shortTime=3600               \
            --with-availExtensions=yes          \
            --with-caseIndependentSorting=no    \
            --with-colorize=yes                 \
            --with-useDotFiles=yes

make install
