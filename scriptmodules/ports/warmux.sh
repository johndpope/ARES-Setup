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
 
rp_module_id="warmux"
rp_module_desc="Warmux - Worms Clone"
rp_module_licence="GPL2 https://raw.githubusercontent.com/yeKcim/warmux/master/LICENSE"
rp_module_section="prt"
rp_module_flags="!mali"
 
function install_bin_warmux() {
    aptInstall warmux
}
 
function configure_warmux() {
    addPort "$md_id" "warmux" "warmux" "/usr/games/warmux"
}
