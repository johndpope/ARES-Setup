#!/usr/bin/env bash

# This file is part of ARES by The RetroArena
#
# ARES is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/Retro-Arena/RetroArena-Setup/master/LICENSE.md
#
# Core script functionality is based upon The RetroPie Project https://retropie.org.uk Script Modules

rp_module_id="mobilegamepad"
rp_module_desc="Mobile Universal Gamepad for ARES"
rp_module_licence="GPL3 https://raw.githubusercontent.com/sbidolach/mobile-gamepad/master/LICENSE"
rp_module_section="driver"
rp_module_flags="noinstclean nobin"

function depends_mobilegamepad() {
    depends_virtualgamepad "$@"
}

function remove_mobilegamepad() {
    pm2 stop app
    pm2 delete app
    rm -f /etc/apt/sources.list.d/nodesource.list
}

function sources_mobilegamepad() {
    gitPullOrClone "$md_inst" https://github.com/sbidolach/mobile-gamepad.git
    chown -R $user:$user "$md_inst"
}

function install_mobilegamepad() {
    npm install -g grunt-cli
    npm install pm2 -g --unsafe-perm
    cd "$md_inst"
    sudo -u $user npm install
}

function configure_mobilegamepad() {
    [[ "$md_mode" == "remove" ]] && return
    pm2 start app.sh
    pm2 startup
    pm2 save
}
