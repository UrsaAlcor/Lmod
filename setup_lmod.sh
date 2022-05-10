#!/bin/bash

set -xe

# Get Arguments
# =================
cwdpath=$(pwd)
arch=${1:-x86_64}
origin=${2:-$cwdpath}

# =================

lmod_install=$origin/lmod
modules=$origin/lmod/modules
dist=$origin/lmod/dist

# Use noarch lua
lua_version=$(cd subprojects/lua && git describe --tags --abbrev=0)

# We can only generate LMOD install with a valid lua install
# Because of our lua noarch wrapper we can reuse a x86_64 install
# with other archs
# if you want this to execute you can first install x86 lua
# then the target arch 
if [[ -f "$dist/$(arch)/lua/$lua_version/bin/lua" ]]; then

    lua=$dist/noarch/lua/$lua_version/bin/lua
    luac=$dist/noarch/lua/$lua_version/bin/luac

    # Setup lmod using lua noarch
    lmod_src=$origin/subprojects/lmod
    lmod_version=$(cd subprojects/lmod && git describe --tags --abbrev=0)
    lmod_base=$lmod_install/$lmod_version/
    lmod_config=$lmod_install/config
    lmod_modulespath=$lmod_config/modulespath

    mkdir -p $lmod_base

    #   the `noarch` arch folder is missing :(
    #   --prefix=/opt/apps => /opt/apps/lmod/X.Y
    #

    cd $lmod_src

    # We can define module files folder using
    #   1. /root/modulefiles/$LMOD_sys
    #   2. –with-ModulePathInit=...  (default: /apps/lmod/lmod/init/.modulespath)
    #   3. MODULEPATH_ROOT (define it before z00_lmod.*)
    #   4. $LMOD_SITE_MODULEPATH (defined before the z00_lmod.* )

    # apps/lmod/lmod
    # 
    ./configure --prefix="$origin"                  \
                --with-lua="$lua"                   \
                --with-luac="$luac"                 \
                --with-tcl=no                       \
                --with-ModulePathInit=$lmod_config  \
                --with-shortTime=3600               \
                --with-availExtensions=yes          \
                --with-caseIndependentSorting=no    \
                --with-colorize=yes                 \
                --with-useDotFiles=yes              \
                --with-module-root-path="$modules/\$(arch)"  \
                # -sysconfdir

    make install

    # Create a standard environment
    mkdir -p $origin/lmod/modules/$arch/StdEnv
    sed -e "s@\${ALCOR_DIST}@$dist@g" $origin/templates/StdEnv.lua > $origin/lmod/modules/$arch/StdEnv/2022.lua
    cd $origin/lmod/modules/$arch/StdEnv/
    ln -f -s 2022.lua default

    # mkdir -p $lmod_config
    # mkdir -p lmod/scripts
    # cp relocate.sh lmod/scripts/

    # Copy configuration files
    # cp $origin/config/lmod* lmod/config/
    # cp -R $origin/etc/ lmod/config/etc
fi
