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

rp_module_id="lr-vemulator"
rp_module_desc="Sega Dreamcast VMU port for libretro"
rp_module_help="ROM Extensions: .vms .bin .zip\n\nCopy your vmu roms to $romdir/svmu"
rp_module_licence="BSD-3 https://raw.githubusercontent.com/MJaoune/vemulator-libretro/master/LICENSE"
rp_module_section="lr"

function sources_lr-vemulator() {
    gitPullOrClone "$md_build" https://github.com/MJaoune/vemulator-libretro.git
}

function build_lr-vemulator() {
    make clean
    make
    md_ret_require="$md_build/vemulator_libretro.so"
}

function install_lr-vemulator() {
    md_ret_files=(
        'vemulator_libretro.so'
    )
}

function configure_lr-vemulator() {
    mkRomDir "svmu"
    ensureSystemretroconfig "svmu"

    addEmulator 1 "$md_id" "svmu" "$md_inst/vemulator_libretro.so"
    addSystem "svmu"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/$system/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/$system/"
}
