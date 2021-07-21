if ( -d "$HOME/.modulefiles/" ) then
    module -q use --priority 100 "$HOME/.modulefiles/"
endif
