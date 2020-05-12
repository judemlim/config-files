
case $1 in
    t)
        i3-msg "[instance="dropdown"] scratchpad show; [instance="dropdown"] move position center"
        if [[ $? -ne 0 ]]; then
            i3-msg "exec --no-startup-id urxvt -name dropdown;"
            sleep 0.2
            i3-msg "[instance="dropdown"] scratchpad show; [instance="dropdown"] move position center"
        fi
        ;;
    r)
        i3-msg "[instance="file_explorer"] scratchpad show; [instance="file_explorer"] move position center"
        if [[ $? -ne 0 ]]; then
            i3-msg "exec --no-startup-id urxvt -name file_explorer -e ranger"
            sleep 0.2
            i3-msg "[instance="file_explorer"] scratchpad show; [instance="file_explorer"] move position center"
        fi
        ;;
esac


