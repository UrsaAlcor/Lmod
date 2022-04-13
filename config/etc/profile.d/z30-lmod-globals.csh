setenv  LMOD_PACKAGE_PATH  "$LMOD_ROOT/etc/lmod"
setenv  LMOD_RC            "$LMOD_PACKAGE_PATH/lmodrc.lua"
setenv  LMOD_ADMIN_FILE    "$LMOD_PACKAGE_PATH/admin.list"
if ( ! $?LMOD_AVAIL_STYLE ) then
    setenv  LMOD_AVAIL_STYLE   "system:<grouped>"
endif
if ( ! $?LMOD_SYSTEM_DEFAULT_MODULES ) then
    setenv  LMOD_SYSTEM_DEFAULT_MODULES   "StdEnv"
endif
