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

rp_module_id="ags"
rp_module_desc="Adventure Game Studio - Adventure game engine"
rp_module_help="ROM Extension: .exe\n\nCopy your Adventure Game Studio roms to $romdir/ags"
rp_module_licence="OTHER https://raw.githubusercontent.com/adventuregamestudio/ags/master/License.txt"
rp_module_section="sa"
rp_module_flags="!mali"

function depends_ags() {
    getDepends xorg pkg-config libaldmb1-dev libfreetype6-dev libtheora-dev libvorbis-dev libogg-dev liballegro4-dev
}

function sources_ags() {
    gitPullOrClone "$md_build" https://github.com/adventuregamestudio/ags.git ags3
}

function build_ags() {
    make -C Engine clean
    make -C Engine
}

function install_ags() {
    make -C Engine PREFIX="$md_inst" install
}

function configure_ags() {
    local binary="$md_inst/bin/ags"
    local params=("--fullscreen %ROM%")
    if ! isPlatform "x11"; then
        binary="xinit $binary"
        params+=("--gfxdriver software")
    fi

    mkRomDir "ags"
	

    # install Eawpatches GUS patch set (see: http://liballeg.org/digmid.html)
    [[ "$md_mode" == "install" ]] && wget -qO- "http://www.eglebbk.dds.nl/program/download/digmid.dat" | bzcat >"$md_inst/bin/patches.dat"

    addEmulator 1 "$md_id" "ags" "$binary ${params[*]}" "Adventure Game Studio" ".exe"

    addSystem "ags"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/$system/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/$system/"
	}
