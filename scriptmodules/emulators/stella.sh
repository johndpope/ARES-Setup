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

rp_module_id="stella"
rp_module_desc="Atari2600 emulator STELLA"
rp_module_help="ROM Extensions: .a26 .bin .rom .zip .gz\n\nCopy your Atari 2600 roms to $romdir/atari2600"
rp_module_licence="GPL2 https://raw.githubusercontent.com/stella-emu/stella/master/License.txt"
rp_module_section="sa"
rp_module_flags="!odroid-n2"

function depends_stella() {
    getDepends libsdl2-dev libpng-dev zlib1g-dev xz-utils
}

function sources_stella() {
    gitPullOrClone "$md_build" "https://github.com/stella-emu/stella.git" 6.0.1
}

function build_stella() {
    ./configure --prefix="$md_inst"
    make clean
    make
    md_ret_require="$md_build/stella"
}

function install_stella() {
    make install
}

function configure_stella() {
    mkRomDir "atari2600"

    moveConfigDir "$home/.config/stella" "$md_conf_root/atari2600/stella"

    addEmulator 1 "$md_id" "atari2600" "$md_inst/bin/stella -maxres 320x240 -fullscreen 1 -tia.fsfill 1 %ROM%"
    addSystem "atari2600"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/$system/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/$system/"
}
