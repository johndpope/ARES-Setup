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

rp_module_id="lr-kronos"
rp_module_desc="Saturn & ST-V emulator - Kronos port for libretro"
rp_module_help="ROM Extensions: .iso .cue .zip .ccd .mds\n\nCopy your Sega Saturn & ST-V roms to $romdir/saturn\n\nCopy the required BIOS file saturn_bios.bin / stvbios.zip to $biosdir/kronos"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/yabause/kronos/yabause/COPYING"
rp_module_section="lr"
rp_module_flags="!arm !aarch64"

function sources_lr-kronos() {
    gitPullOrClone "$md_build" https://github.com/libretro/yabause.git kronos
}

function build_lr-kronos() {
    cd yabause/src/libretro
    make clean
    make
    md_ret_require="$md_build/yabause/src/libretro/kronos_libretro.so"
}

function install_lr-kronos() {
    md_ret_files=(
        'yabause/src/libretro/kronos_libretro.so'
        'yabause/AUTHORS'
        'yabause/COPYING'
        'yabause/ChangeLog'
        'yabause/GOALS'
        'yabause/README'
        'yabause/README.LIN'
    )
}

function configure_lr-kronos() {
    mkRomDir "saturn"
    ensureSystemretroconfig "saturn"

    addEmulator 1 "$md_id" "saturn" "$md_inst/kronos_libretro.so"
    addSystem "saturn"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/$system/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/$system/"
}
