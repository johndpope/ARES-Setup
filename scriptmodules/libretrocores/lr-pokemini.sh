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

rp_module_id="lr-pokemini"
rp_module_desc="Pokemon Mini emulator - PokeMini port for libretro"
rp_module_help="ROM Extensions: .min .zip\n\nCopy your Pokemon Mini roms to $romdir/pokemini"
rp_module_licence="GPL3 https://raw.githubusercontent.com/libretro/PokeMini/master/LICENSE"
rp_module_section="lr"

function sources_lr-pokemini() {
    gitPullOrClone "$md_build" https://github.com/libretro/pokemini.git
}

function build_lr-pokemini() {
    make clean
    make
    md_ret_require="$md_build/pokemini_libretro.so"
}

function install_lr-pokemini() {
    md_ret_files=(
        'pokemini_libretro.so'
    )
}

function configure_lr-pokemini() {
    mkRomDir "pokemini"
    ensureSystemretroconfig "pokemini"

    addEmulator 1 "$md_id" "pokemini" "$md_inst/pokemini_libretro.so"
    addSystem "pokemini"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/$system/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/$system/"
}
