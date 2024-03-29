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

rp_module_id="lr-px68k"
rp_module_desc="SHARP X68000 Emulator"
rp_module_help="You need to copy a X68000 bios file (iplrom30.dat, iplromco.dat, iplrom.dat, or iplromxv.dat), and the font file (cgrom.dat or cgrom.tmp) to $romdir/BIOS/keropi. Use F12 to access the in emulator menu."
rp_module_section="lr"
rp_module_flags=""

function sources_lr-px68k() {
    gitPullOrClone "$md_build" https://github.com/libretro/px68k-libretro.git
}

function build_lr-px68k() {
    make clean
    make
    md_ret_require="$md_build/px68k_libretro.so"
}

function install_lr-px68k() {
    md_ret_files=(
        'px68k_libretro.so'
        'README.MD'
        'readme.txt'
    )
}

function configure_lr-px68k() {
    mkRomDir "x68000"
    ensureSystemretroconfig "x68000"

    mkUserDir "$biosdir/keropi"

    addEmulator 1 "$md_id" "x68000" "$md_inst/px68k_libretro.so"
    addSystem "x68000"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/$system/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/$system/"
}
