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

rp_module_id="lr-bsnes"
rp_module_desc="Super Nintendo emu - bsnes port for libretro"
rp_module_help="ROM Extensions: .bin .smc .sfc .fig .swc .mgd .zip\n\nCopy your SNES roms to $romdir/snes"
rp_module_licence="GPL3 https://raw.githubusercontent.com/libretro/bsnes-libretro/libretro/COPYING"
rp_module_section="lr"
rp_module_flags=""

function sources_lr-bsnes() {
    gitPullOrClone "$md_build" https://github.com/libretro/bsnes-libretro.git
}

function build_lr-bsnes() {
    make clean
    make
    md_ret_require="$md_build/out/bsnes_accuracy_libretro.so"
}

function install_lr-bsnes() {
    md_ret_files=(
        'out/bsnes_accuracy_libretro.so'
        'COPYING'
    )
}

function configure_lr-bsnes() {
    mkRomDir "snes"
    ensureSystemretroconfig "snes"

    addEmulator 1 "$md_id" "snes" "$md_inst/bsnes_accuracy_libretro.so"
    addSystem "snes"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/$system/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/$system/"
}
