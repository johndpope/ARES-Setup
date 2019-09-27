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

rp_module_id="barrage"
rp_module_desc="barrage - Shooting Range action game"
rp_module_licence="GPL2 https://sourceforge.net/p/lgames/code/HEAD/tree/trunk/barrage/COPYING"
rp_module_section="prt"
rp_module_flags="!mali"

function install_bin_barrage() {
     aptInstall barrage
}

function configure_barrage() {
    mkRomDir "ports"
    moveConfigFile "$home/.lgames/barrage.conf" "$md_conf_root/barrage/barrage.conf"
    addPort "$md_id" "barrage" "barrage - Shooting Range action game" "xinit /usr/games/barrage"
}
