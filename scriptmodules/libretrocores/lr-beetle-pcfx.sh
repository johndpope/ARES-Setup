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

rp_module_id="lr-beetle-pcfx"
rp_module_desc="PCFX emulator - Mednafen PCFX Port for libretro"
rp_module_help="ROM Extensions: .img .iso .ccd .cue\n\nCopy the required BIOS file pcfx.rom to $biosdir"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/beetle-pcfx-libretro/master/COPYING"
rp_module_section="lr"

function sources_lr-beetle-pcfx() {
    gitPullOrClone "$md_build" https://github.com/libretro/beetle-pcfx-libretro
}

function build_lr-beetle-pcfx() {
    make clean
    make
    md_ret_require="$md_build/mednafen_pcfx_libretro.so"
}

function install_lr-beetle-pcfx() {
    md_ret_files=(
        'mednafen_pcfx_libretro.so'
    )
}

function configure_lr-beetle-pcfx() {
    mkRomDir "pcfx"
    ensureSystemretroconfig "pcfx"

    addEmulator 1 "$md_id" "pcfx" "$md_inst/mednafen_pcfx_libretro.so"
    addSystem "pcfx"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/$system/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/$system/"
}
