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
#

rp_module_id="rawgl"
rp_module_desc="rawgl - Another World Engine"
rp_module_help="Please copy your Another World data files to $romdir/ports/$md_id before running the game."
rp_module_section="prt"
rp_module_flags=" !x86"

function depends_rawgl() {
    getDepends g++ libsdl2-dev libsdl2-mixer-dev
}

function sources_rawgl() {
    gitPullOrClone "$md_build" https://github.com/cyxx/rawgl.git
}

function build_rawgl() {
    make clean
    make
    md_ret_require="$md_build/rawgl"
}

function install_rawgl() {
    md_ret_files=('rawgl')
}

function configure_rawgl() {
    mkRomDir "ports"
    mkRomDir "ports/$md_id"

    addPort "$md_id" "rawgl" "rawgl - Another World Engine" "$md_inst/rawgl --datapath=$romdir/ports/$md_id --language=us --render=original --fullscreen-ar"
}
