#!/bin/sh

# Activates the lmod installation
# ===============================

origin=$(pwd)
root=$origin/lmod
modules=$origin/lmod/modules/$(arch)

# export ALCOR_DIST=$origin/lmod/dist/$(arch)
export MODULEPATH_ROOT=$modules
export MODULEPATH=$modules
export LMOD_SYSTEM_DEFAULT_MODULES=${LMOD_SYSTEM_DEFAULT_MODULES:-"StdEnv"}

source $root/lmod/init/profile

if [ -z "$__Init_Default_Modules" ]; then
   export __Init_Default_Modules=1;

   ## ability to predefine elsewhere the default list
   LMOD_SYSTEM_DEFAULT_MODULES=${LMOD_SYSTEM_DEFAULT_MODULES:-"StdEnv"}
   export LMOD_SYSTEM_DEFAULT_MODULES
   module --initial_load --no_redirect restore
else
   module refresh
fi

type module
