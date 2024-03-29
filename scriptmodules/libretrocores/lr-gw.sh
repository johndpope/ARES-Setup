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

rp_module_id="lr-gw"
rp_module_desc="Game and Watch simulator"
rp_module_help="ROM Extension: .mgw\n\nCopy your Game and Watch games to $romdir/gameandwatch"
rp_module_licence="ZLIB https://raw.githubusercontent.com/libretro/gw-libretro/master/LICENSE"
rp_module_section="lr"

function sources_lr-gw() {
    gitPullOrClone "$md_build" https://github.com/libretro/gw-libretro.git
}

function build_lr-gw() {
    make -f Makefile.libretro clean
    make -f Makefile.libretro
    md_ret_require="$md_build/gw_libretro.so"
}

function install_lr-gw() {
    md_ret_files=(
        'gw_libretro.so'
        'LICENSE'
        'README.md'
    )
}

function configure_lr-gw() {
    mkRomDir "gameandwatch"
    ensureSystemretroconfig "gameandwatch"

    addEmulator 1 "$md_id" "gameandwatch" "$md_inst/gw_libretro.so"
    addSystem "gameandwatch"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/$system/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/$system/"
}
