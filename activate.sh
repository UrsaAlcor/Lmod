#!/bin/sh

origin=$(pwd)
base=$origin/modules

export MODDULEPATH=$base
source $base/lmod/lmod/init/profile

type module
