if [ -z "$__Init_Default_Modules" ]; then
    __Init_Default_Modules=1
    export __Init_Default_Modules
    
    #
    # Carry out module restore operation.
    #
    # Per https://lmod.readthedocs.io/en/latest/070_standard_modules.html, the flag
    # --no_redirect is recommended because scp craps out when text is printed on
    # stdout in /etc/profile.
    #
    # The Compute Canada folks recommend switching here on interactive shells.
    # If shell flags $- have an "i" (interactive) in them, noisily restore.
    #
    if [ "$-" == *i* ]; then
        module    --initial_load --no_redirect restore
    else
        module -q --initial_load --no_redirect restore
    fi
else
    module refresh
fi
