if grep -Fq 'disable_menu = "0"' "/opt/ares/configs/all/runcommand.cfg"; then
    RALV="$HOME/ARES/launchingvideos"
    if [[ -e "$HOME/.config/launchingvideos" ]]; then
        if [[ -e "$RALV/system-exit.mp4" ]]; then
            if grep -q "ODROID-N2" /sys/firmware/devicetree/base/model 2>/dev/null; then
                mpv -really-quiet -vo sdl -fs "$RALV/system-exit.mp4" </dev/tty &>/dev/null
            elif grep -q "RockPro64" /sys/firmware/devicetree/base/model 2>/dev/null; then
                mpv -really-quiet -vo sdl -fs "$RALV/system-exit.mp4" </dev/tty &>/dev/null
            else
                mpv -really-quiet -vo sdl -fs "$RALV/system-exit.mp4" </dev/tty &>/dev/null
            fi
        fi
    fi
fi

if [[ -e "$HOME/.config/bgmtoggle" ]]; then
    (sleep 2; pkill -CONT mpg123) &
fi

if [[ -e "$HOME/.config/esreload" ]]; then
    bash /opt/ares/configs/all/runcommand-esreload.sh &>/dev/null
fi
