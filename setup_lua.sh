#!/bin/bash

set -xe

# Get Arguments
# =================

arch=${1:-x86_64}

cwdpath=$(pwd)
origin=${2:-$cwdpath}

# =================
# Setup Paths
# -----------------

base=$origin/lmod
modules=$base/modules/$arch
dist=$base/dist

# =================
rm -rf build
meson subprojects download

version=$(cd subprojects/lua && git describe --tags --abbrev=0)
loc=$dist/$arch/lua/$version

mkdir -p $loc/bin
rm -rf $loc/bin/*

# Setup cross compilation
cd $origin/lua/buildroot/$arch

make -C $origin/subprojects/buildroot-2021.08 V=1 O=$(pwd)
export PATH="$(pwd)/host/bin:$PATH"

cd $origin

# =================
# Compile & Install Lua

# Standard Meson build
meson setup -Dprefix=$loc       \
            -Dbindir='bin'      \
            -Dbuildtype=minsize \
            -Db_staticpic=false \
            -Db_ndebug=true     \
            -Db_lto=true        \
            build .       

meson compile -C build
meson install -C build

mkdir -p $dist/$arch/lua/$version
mkdir -p $dist/noarch/lua/$version

# Make a bash wrapper that will select the right arch at runtime
echo -e "#!/bin/sh\nexec \"$dist/\$(uname -m)/lua/$version/bin/lua\" \"\$@\"" > "$dist/noarch/lua/$version/lua"
echo -e "#!/bin/sh\nexec \"$dist/\$(uname -m)/lua/$version/bin/luac\" \"\$@\"" > "$dist/noarch/lua/$version/luac"

chmod 755 $dist/noarch/lua/$version/lua
chmod 755 $dist/noarch/lua/$version/luac

# Create the symbolic link for lua & luac using our unified binary
mv $loc/bin/lua $loc/bin/lua_main
cd $loc/bin

# Make the link relative so it will work anywhere
ln -f -s lua_main lua
ln -f -s lua_main luac

cd $origin

# =================
# Turn our lua installaion into a module

mkdir -p $modules/lua

# Create a standard environment
sed "s@\${LUA_VERSION}@$version@g" $origin/templates/LuaModuleFile.lua > $modules/lua/$version.lua

