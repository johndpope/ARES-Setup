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

rp_module_id="lr-dosbox"
rp_module_desc="DOS emulator"
rp_module_help="ROM Extensions: .bat .com .exe .sh\n\nCopy your DOS games to $ROMDIR/pc"
rp_module_licence="https://raw.githubusercontent.com/libretro/dosbox-libretro/master/COPYING"
rp_module_section="lr"
rp_module_flags=""

function sources_lr-dosbox() {
    gitPullOrClone "$md_build" https://github.com/libretro/dosbox-libretro.git
}

function build_lr-dosbox() {
    local params=()
    if isPlatform "arm"; then
        if isPlatform "armv6"; then
            params+="WITH_DYNAREC=oldarm"
        else
            params+="WITH_DYNAREC=arm"
        fi
    fi
    make clean
    make "${params[@]}"
    md_ret_require="$md_build/dosbox_libretro.so"
}

function install_lr-dosbox() {
    md_ret_files=(
        'COPYING'
        'dosbox_libretro.so'
        'README'
    )
}

function configure_lr-dosbox() {
    mkRomDir "pc"
    ensureSystemretroconfig "pc"

    addEmulator 0 "$md_id" "pc" "$md_inst/dosbox_libretro.so"
    addSystem "pc"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/$system/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/$system/"
}
