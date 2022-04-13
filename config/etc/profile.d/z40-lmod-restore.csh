if ( ! $?__Init_Default_Modules )  then
    setenv __Init_Default_Modules 1
    module -q --initial_load --no_redirect restore
else
    module refresh
endif
