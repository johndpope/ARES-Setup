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

rp_module_id="lr-puae"
rp_module_desc="P-UAE Amiga emulator port for libretro"
rp_module_help="ROM Extensions: .adf .uae\n\nCopy your roms to $romdir/amiga and create configs as .uae"
rp_module_licence="GPL2"
rp_module_section="lr"

function sources_lr-puae() {
    gitPullOrClone "$md_build" https://github.com/libretro/libretro-uae.git
}

function build_lr-puae() {
    make
    md_ret_require="$md_build/puae_libretro.so"
}

function install_lr-puae() {
    md_ret_files=(
        'puae_libretro.so'
        'README'
    )
}

function configure_lr-puae() {
    mkRomDir "amiga"
    ensureSystemretroconfig "amiga"
    addEmulator 1 "$md_id" "amiga" "$md_inst/puae_libretro.so"
    addSystem "amiga"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/$system/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/$system/"
}
