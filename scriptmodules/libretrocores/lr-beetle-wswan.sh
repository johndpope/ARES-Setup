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

rp_module_id="lr-beetle-wswan"
rp_module_desc="Wonderswan emu - Mednafen WonderSwan core port for libretro"
rp_module_help="ROM Extensions: .ws .wsc .zip\n\nCopy your Wonderswan roms to $romdir/wonderswan\n\nCopy your Wonderswan Color roms to $romdir/wonderswancolor"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/beetle-wswan-libretro/master/COPYING"
rp_module_section="lr"

function _update_hook_lr-beetle-wswan() {
    # move from old location and update emulators.cfg
    renameModule "lr-mednafen-wswan" "lr-beetle-wswan"
}

function sources_lr-beetle-wswan() {
    gitPullOrClone "$md_build" https://github.com/libretro/beetle-wswan-libretro.git
}

function build_lr-beetle-wswan() {
    make clean
    make
    md_ret_require="$md_build/mednafen_wswan_libretro.so"
}

function install_lr-beetle-wswan() {
    md_ret_files=(
        'mednafen_wswan_libretro.so'
    )
}

function configure_lr-beetle-wswan() {
    mkRomDir "wonderswan"
    mkRomDir "wonderswancolor"
    ensureSystemretroconfig "wonderswan"
    ensureSystemretroconfig "wonderswancolor"

    addEmulator 1 "$md_id" "wonderswan" "$md_inst/mednafen_wswan_libretro.so"
    addEmulator 1 "$md_id" "wonderswancolor" "$md_inst/mednafen_wswan_libretro.so"
    addSystem "wonderswan"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/wonderswan/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/wonderswan/"
    addSystem "wonderswancolor"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/wonderswancolor/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/wonderswancolor/"
}
