#!/bin/bash

origin=$(pwd)
lmod_install=$origin/lmod
modules=$lmod_install/modules

# Use noarch lua
lua_version=$(cd subprojects/lua && git describe --tags --abbrev=0)
lua=$modules/lua/$lua_version/noarch/lua
luac=$modules/lua/$lua_version/noarch/luac

# Setup lmod using lua noarch
lmod_src=$origin/subprojects/lmod
lmod_version=$(cd subprojects/lmod && git describe --tags --abbrev=0)
lmod_base=$lmod_install/$lmod_version/
lmod_config=$lmod_install/config
lmod_modulespath=$lmod_config/modulespath

mkdir -p $lmod_config
mkdir -p $lmod_base

#   the `noarch` arch folder is missing :(
#   --prefix=/opt/apps => /opt/apps/lmod/X.Y
#

cd $lmod_src

./configure --prefix="$origin"                  \
            --with-lua="$lua"                   \
            --with-luac="$luac"                 \
            --with-tcl=no                       \
            --with-module-root-path="$modules"  \
            --with-ModulePathInit=$lmod_config  \
            --with-shortTime=3600               \
            --with-availExtensions=yes          \
            --with-caseIndependentSorting=no    \
            --with-colorize=yes                 \
            --with-useDotFiles=yes
            # -sysconfdir

make install

# Copy configuration files
cp $origin/config/* lmod/config/
