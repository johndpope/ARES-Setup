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

rp_module_id="freesynd"
rp_module_desc="freesynd - Syndicate Engine"
rp_module_licence="GPL2 https://sourceforge.net/p/freesynd/code/HEAD/tree/freesynd/trunk/COPYING?format=raw"
rp_module_help="Please place your required Syndicate data files in /opt/ares/ports/freesynd."
rp_module_section="prt"
rp_module_flags="!x86 !mali"

function depends_freesynd() {
    getDepends libsdl1.2-dev libsdl-mixer1.2-dev subversion libsdl-image1.2-dev libpng-dev cmake
}

function sources_freesynd() {
    svn checkout svn://svn.code.sf.net/p/freesynd/code/ freesynd-code
}

function build_freesynd() {
    cd "$md_build/freesynd-code/freesynd/tags/release-0.7.1"
    cmake . -DCMAKE_INSTALL_PREFIX:PATH="$md_inst"
    make
    md_ret_require="$md_build/freesynd-code/freesynd/tags/release-0.7.1/src/freesynd"
}

function install_freesynd() {
    cd "$md_build/freesynd-code/freesynd/tags/release-0.7.1"
    md_ret_files=(
        'freesynd-code/freesynd/tags/release-0.7.1/src/freesynd'
        'freesynd-code/freesynd/tags/release-0.7.1/data'
    )
}

function configure_freesynd() {
    mkRomDir "ports"
    mkRomDir "ports/freesynd"
    moveConfigDir "$home/.freesynd" "$md_conf_root/freesynd"
    cp "$md_data/freesynd.ini" "$md_conf_root/$md_id"
    addPort "$md_id" "freesynd" "FreeSynd - Syndicate Engine" "xinit $md_inst/freesynd" 
}
