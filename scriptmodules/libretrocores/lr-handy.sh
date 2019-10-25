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

rp_module_id="lr-handy"
rp_module_desc="Atari Lynx emulator - Handy port for libretro"
rp_module_help="ROM Extensions: .lnx .zip\n\nCopy your Atari Lynx roms to $romdir/atarilynx"
rp_module_licence="ZLIB https://raw.githubusercontent.com/libretro/libretro-handy/master/lynx/license.txt"
rp_module_section="lr"

function sources_lr-handy() {
    gitPullOrClone "$md_build" https://github.com/libretro/libretro-handy.git
}

function build_lr-handy() {
    make clean
    make
    md_ret_require="$md_build/handy_libretro.so"
}

function install_lr-handy() {
    md_ret_files=(
        'handy_libretro.so'
        'README.md'
    )
}

function configure_lr-handy() {
    mkRomDir "atarilynx"
    ensureSystemretroconfig "atarilynx"

    addEmulator 1 "$md_id" "atarilynx" "$md_inst/handy_libretro.so"
    addSystem "atarilynx"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/$system/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/$system/"
}
