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

rp_module_id="lr-81"
rp_module_desc="Sinclair ZX81 emulator - EightyOne port for libretro"
rp_module_help="ROM Extensions: .p .tzx .t81\n\nCopy your ZX81 roms to $romdir/zx81"
rp_module_licence="GPL3 https://github.com/libretro/81-libretro/blob/master/LICENSE"
rp_module_section="lr"

function sources_lr-81() {
    gitPullOrClone "$md_build" https://github.com/libretro/81-libretro.git
}

function build_lr-81() {
    make clean
    make
    md_ret_require="$md_build/81_libretro.so"
}

function install_lr-81() {
    md_ret_files=(
        'README.md'
        '81_libretro.so'
    )
}

function configure_lr-81() {
    mkRomDir "zx81"
    ensureSystemretroconfig "zx81"

    addEmulator 1 "$md_id" "zx81" "$md_inst/81_libretro.so"
    addSystem "zx81"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/$system/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/$system/"
}
