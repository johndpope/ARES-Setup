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

rp_module_id="lr-gambatte"
rp_module_desc="Gameboy Color emu - libgambatte port for libretro"
rp_module_help="ROM Extensions: .gb .gbc .zip\n\nCopy your GameBoy roms to $romdir/gb\n\nCopy your GameBoy Color roms to $romdir/gbc"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/gambatte-libretro/master/COPYING"
rp_module_section="lr"

function sources_lr-gambatte() {
    gitPullOrClone "$md_build" https://github.com/libretro/gambatte-libretro.git
}

function build_lr-gambatte() {
    make -f Makefile.libretro clean
    make -f Makefile.libretro
    md_ret_require="$md_build/gambatte_libretro.so"
}

function install_lr-gambatte() {
    md_ret_files=(
        'COPYING'
        'changelog'
        'README.md'
        'gambatte_libretro.so'
    )
}

function configure_lr-gambatte() {
    # add default green yellow palette for gameboy classic
    mkUserDir "$biosdir/palettes"
    cp "$md_data/default.pal" "$biosdir/palettes/"
    chown $user:$user "$biosdir/palettes/default.pal"
    setRetroArchCoreOption "gambatte_gb_colorization" "custom"

    mkRomDir "gbc"
    mkRomDir "gb"
    ensureSystemretroconfig "gb"
    ensureSystemretroconfig "gbc"
    addEmulator 1 "$md_id" "gb" "$md_inst/gambatte_libretro.so"
    addEmulator 1 "$md_id" "gbc" "$md_inst/gambatte_libretro.so"
    addSystem "gb"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/gb/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/gb/"
    addSystem "gbc"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/gbc/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/gbc/"
}
