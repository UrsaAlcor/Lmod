#!/bin/sh

# Activates the lmod installation
# ===============================

origin=$(pwd)
root=$origin/lmod
modules=$origin/lmod/modules/$(arch)

export ALCOR_DIST=$origin/lmod/dist/$(arch)
export MODULEPATH_ROOT=$modules
export MODULEPATH=$modules
export LMOD_SYSTEM_DEFAULT_MODULES=${LMOD_SYSTEM_DEFAULT_MODULES:-"StdEnv"}

source $root/lmod/init/profile

type module
