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

rp_module_id="lr-vba-next"
rp_module_desc="GBA emulator - VBA-M (optimised) port for libretro"
rp_module_help="ROM Extensions: .gba .zip\n\nCopy your Game Boy Advance roms to $romdir/gba\n\nCopy the required BIOS file gba_bios.bin to $biosdir"
rp_module_licence="GPL2"
rp_module_section="lr"
rp_module_flags="!armv6"

function sources_lr-vba-next() {
    gitPullOrClone "$md_build" https://github.com/libretro/vba-next.git
}

function build_lr-vba-next() {
    make -f Makefile.libretro clean
    if isPlatform "neon"; then
        make -f Makefile.libretro platform=armvhardfloatunix TILED_RENDERING=1 HAVE_NEON=1
    else
        make -f Makefile.libretro
    fi
    md_ret_require="$md_build/vba_next_libretro.so"
}

function install_lr-vba-next() {
    md_ret_files=(
        'vba_next_libretro.so'
    )
}

function configure_lr-vba-next() {
    mkRomDir "gba"
    ensureSystemretroconfig "gba"

    addEmulator 0 "$md_id" "gba" "$md_inst/vba_next_libretro.so"
    addSystem "gba"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/$system/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/$system/"
}
