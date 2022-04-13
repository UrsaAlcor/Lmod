#!/bin/sh

# Activates the lmod installation
# ===============================

origin=$(pwd)
root=$origin/lmod
modules=$origin/lmod/modules

export MODULEPATH_ROOT=$modules
export MODULEPATH=$modules
source $root/lmod/init/profile

type module
