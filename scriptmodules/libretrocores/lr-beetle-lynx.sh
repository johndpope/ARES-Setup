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

rp_module_id="lr-beetle-lynx"
rp_module_desc="Atari Lynx emulator - Mednafen Lynx Port for libretro, itself a fork of Handy"
rp_module_help="ROM Extensions: .lnx .zip\n\nCopy your Atari Lynx roms to $romdir/atarilynx\n\nCopy the required BIOS file lynxboot.img to $biosdir"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/beetle-lynx-libretro/master/COPYING"
rp_module_section="lr"

function sources_lr-beetle-lynx() {
    gitPullOrClone "$md_build" https://github.com/libretro/beetle-lynx-libretro.git
}

function build_lr-beetle-lynx() {
    make clean
    make
    md_ret_require="$md_build/mednafen_lynx_libretro.so"
}

function install_lr-beetle-lynx() {
    md_ret_files=(
        'mednafen_lynx_libretro.so'
    )
}

function configure_lr-beetle-lynx() {
    mkRomDir "atarilynx"
    ensureSystemretroconfig "atarilynx"

    addEmulator 0 "$md_id" "atarilynx" "$md_inst/mednafen_lynx_libretro.so"
    addSystem "atarilynx"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/$system/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/$system/"
}
