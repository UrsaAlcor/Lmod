set -gx LMOD_PACKAGE_PATH  "$LMOD_ROOT/etc/lmod"
set -gx LMOD_RC            "$LMOD_PACKAGE_PATH/lmodrc.lua"
set -gx LMOD_ADMIN_FILE    "$LMOD_PACKAGE_PATH/admin.list"
if test -z "$LMOD_AVAIL_STYLE"
    set -gx LMOD_AVAIL_STYLE   "system:<grouped>"
end
if test -z "$LMOD_SYSTEM_DEFAULT_MODULES"
    set -gx LMOD_SYSTEM_DEFAULT_MODULES   "StdEnv"
end
