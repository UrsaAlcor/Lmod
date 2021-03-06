# Certain rare shells don't support combined export VAR=val syntax.

LMOD_PACKAGE_PATH="$LMOD_ROOT/etc/lmod"
LMOD_RC="$LMOD_PACKAGE_PATH/lmodrc.lua"
LMOD_ADMIN_FILE="$LMOD_PACKAGE_PATH/admin.list"
LMOD_AVAIL_STYLE=${LMOD_AVAIL_STYLE:-"system:<grouped>"}
LMOD_SYSTEM_DEFAULT_MODULES=${LMOD_SYSTEM_DEFAULT_MODULES:-"StdEnv"}

export LMOD_PACKAGE_PATH
export LMOD_RC
export LMOD_ADMIN_FILE
export LMOD_AVAIL_STYLE
export LMOD_SYSTEM_DEFAULT_MODULES
