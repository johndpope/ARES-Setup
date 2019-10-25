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

rp_module_id="lr-o2em"
rp_module_desc="Odyssey 2 / Videopac emu - O2EM port for libretro"
rp_module_help="ROM Extensions: .bin .zip\n\nCopy your Odyssey 2 / Videopac roms to $romdir/videopac\n\nCopy the required BIOS file o2rom.bin to $biosdir"
rp_module_licence="OTHER"
rp_module_section="lr"

function sources_lr-o2em() {
    gitPullOrClone "$md_build" https://github.com/libretro/libretro-o2em
}

function build_lr-o2em() {
    make clean
    make
    md_ret_require="$md_build/o2em_libretro.so"
}

function install_lr-o2em() {
    md_ret_files=(
        'o2em_libretro.so'
        'README.md'
    )
}

function configure_lr-o2em() {
    mkRomDir "videopac"
    mkRomDir "odyssey2"
    ensureSystemretroconfig "videopac"
    ensureSystemretroconfig "odyssey2"

    addEmulator 1 "$md_id" "videopac" "$md_inst/o2em_libretro.so"
    addSystem "videopac"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/videopac/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/videopac/"
    addEmulator 1 "$md_id" "odyssey2" "$md_inst/o2em_libretro.so"
    addSystem "odyssey2"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/odyssey2/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/odyssey2/"
}
