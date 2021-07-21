if test -z "$__Init_Default_Modules"
    set -gx __Init_Default_Modules 1
    module -q --initial_load --no_redirect restore
else
    module refresh
end
