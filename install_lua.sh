#!/bin/bash

origin=$(pwd)
base=$origin/modules

arch=${1:-x86_64}

rm -rf build
meson subprojects download

version=$(cd subprojects/lua && git describe --tags --abbrev=0)
loc=$base/lua/$version/$arch

mkdir -p $loc/bin
rm -rf $loc/bin/*

# Setup cross compilation
cd $origin/lua/buildroot/$arch
make -C $origin/subprojects/buildroot-2021.08 V=1 O=$(pwd)
export PATH="$(pwd)/host/bin:$PATH"

cd $origin

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

mkdir -p $base/lua/$version/noarch

# Make a bash wrapper that will select the right arch at runtime
echo -e "#!/bin/sh\nexec \"$base/lua/$version/\$(uname -m)/bin/lua\" \"\$@\"" > "$base/lua/$version/noarch/lua"
echo -e "#!/bin/sh\nexec \"$base/lua/$version/\$(uname -m)/bin/luac\" \"\$@\"" > "$base/lua/$version/noarch/luac"

chmod 755 $base/lua/$version/noarch/lua
chmod 755 $base/lua/$version/noarch/luac

# Create the symbolic link for lua
mv $loc/bin/lua $loc/bin/lua_main
cd $loc/bin

# Make the link relative so it will work anywhere
ln -f -s lua_main lua
ln -f -s lua_main luac

cd $origin
