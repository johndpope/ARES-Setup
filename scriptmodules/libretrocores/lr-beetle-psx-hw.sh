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

rp_module_id="lr-beetle-psx-hw"
rp_module_desc="PlayStation emulator - Mednafen PSX Port for libretro with lightrec"
rp_module_help="ROM Extensions: .bin .cue .cbn .img .iso .m3u .mdf .pbp .toc .z .znx\n\nCopy your PlayStation roms to $romdir/psx\n\nCopy the required BIOS files\n\nscph5500.bin and\nscph5501.bin and\nscph5502.bin to\n\n$biosdir"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/beetle-psx-libretro/master/COPYING"
rp_module_section="lr"
rp_module_flags=""

function depends_lr-beetle-psx-hw() {
    local depends=(libgl1-mesa-dev)
    getDepends "${depends[@]}"
}

function sources_lr-beetle-psx-hw() {
    gitPullOrClone "$md_build" https://github.com/ZachCook/beetle-psx-libretro.git lightrec
}

function build_lr-beetle-psx-hw() {
    make clean
    make HAVE_HW=1
    md_ret_require=(
        'mednafen_psx_hw_libretro.so'
    )
}

function install_lr-beetle-psx-hw() {
    md_ret_files=(
        'mednafen_psx_hw_libretro.so'
    )
}
function configure_lr-beetle-psx-hw() {
    mkRomDir "psx"
    ensureSystemretroconfig "psx"

    addEmulator 0 "$md_id" "psx" "$md_inst/mednafen_psx_hw_libretro.so"
    addSystem "psx"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/$system/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/$system/"
}
