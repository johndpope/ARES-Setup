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

rp_module_id="lr-caprice32"
rp_module_desc="Amstrad CPC emu - Caprice32 port for libretro"
rp_module_help="ROM Extensions: .cdt .cpc .dsk .m3u\n\nCopy your Amstrad CPC games to $romdir/amstradcpc"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/libretro-cap32/master/cap32/COPYING.txt"
rp_module_section="lr"

function sources_lr-caprice32() {
    gitPullOrClone "$md_build" https://github.com/libretro/libretro-cap32.git
}

function build_lr-caprice32() {
    make clean
    make
    md_ret_require="$md_build/cap32_libretro.so"
}

function install_lr-caprice32() {
    md_ret_files=(
        'cap32_libretro.so'
    )
}

function configure_lr-caprice32() {
    mkRomDir "amstradcpc"
    mkRomDir "amstradgx4000"
    ensureSystemretroconfig "amstradcpc"
    ensureSystemretroconfig "amstradgx4000"

    setRetroArchCoreOption "cap32_autorun" "enabled"
    setRetroArchCoreOption "cap32_Model" "6128"
    setRetroArchCoreOption "cap32_Ram" "128"
    setRetroArchCoreOption "cap32_combokey" "y"

    addEmulator 1 "$md_id" "amstradcpc" "$md_inst/cap32_libretro.so"
    addSystem "amstradcpc"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/amstradcpc/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/amstradcpc/"
    addEmulator 1 "$md_id" "amstradgx4000" "$md_inst/cap32_libretro.so"
    addSystem "amstradgx4000"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/amstradgx4000/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/amstradgx4000/"
}
