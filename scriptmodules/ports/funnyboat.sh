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

rp_module_id="funnyboat"
rp_module_desc="Funny Boat. A side scrolling boat shooter with waves."
rp_module_licence="GPL2 https://sourceforge.net/p/funnyboat/code/HEAD/tree/trunk/LICENSE-CODE.txt?format=raw"
rp_module_section="prt"
rp_module_flags="!mali !x86"

function install_bin_funnyboat() {
    aptInstall funnyboat
}

function configure_funnyboat() {
    mkRomDir "ports"
    moveConfigDir "$home/.funnyboat" "$md_conf_root/$md_id"

    addPort "$md_id" "funnyboat" "Funny Boat" "xinit funnyboat"
}
