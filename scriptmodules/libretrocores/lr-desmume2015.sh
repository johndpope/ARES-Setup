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

rp_module_id="lr-desmume2015"
rp_module_desc="NDS emu - DESMUME (2015 version)"
rp_module_help="ROM Extensions: .nds .zip\n\nCopy your Nintendo DS roms to $romdir/nds"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/desmume/master/desmume/COPYING"
rp_module_section="lr"

function sources_lr-desmume2015() {
    gitPullOrClone "$md_build" https://github.com/libretro/desmume2015.git
}

function build_lr-desmume2015() {
    cd desmume
    local params=()
    isPlatform "arm" && params+=("platform=armvhardfloat")
    make -f Makefile.libretro clean
    make -f Makefile.libretro "${params[@]}"
    md_ret_require="$md_build/desmume/desmume2015_libretro.so"
}

function install_lr-desmume2015() {
    md_ret_files=(
        'desmume/desmume2015_libretro.so'
    )
}

function configure_lr-desmume2015() {
    mkRomDir "nds"
    ensureSystemretroconfig "nds"

    addEmulator 0 "$md_id" "nds" "$md_inst/desmume2015_libretro.so"
    addSystem "nds"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/$system/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/$system/"
}
