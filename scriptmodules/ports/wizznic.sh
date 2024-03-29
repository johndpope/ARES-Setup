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
 
rp_module_id="wizznic"
rp_module_desc="Wizznic - Puzznic clone"
rp_module_section="prt"
rp_module_flags="!x86 !mali"

function depends_wizznic() {
    getDepends libsdl2-dev libsdl2-mixer-dev libsdl2-image-dev
}
 
function sources_wizznic() {
    gitPullOrClone "$md_build" https://github.com/DusteDdk/Wizznic.git
}
 
function build_wizznic() {
    make -f Makefile.linux
    md_ret_require="$md_build/wizznic"
}
 
function install_wizznic() {
    md_ret_files=(
        'wizznic'
        'data'
        'doc'
        'packs'
    )
}
 
function configure_wizznic() {
    mkRomDir "ports"
    touch "$md_inst/settings.ini"
    moveConfigFile "$md_inst/settings.ini" "$md_conf_root/$md_id/settings.ini"
    chown -R $user:$user "$md_conf_root/$md_id"
    addPort "$md_id" "wizznic" "Wizznic - Puzznic clone" "pushd $md_inst; sudo xinit $md_inst/wizznic -f; popd"
}
