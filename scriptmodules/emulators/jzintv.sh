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

rp_module_id="jzintv"
rp_module_desc="Intellivision emulator"
rp_module_help="ROM Extensions: .int .bin\n\nCopy your Intellivision roms to $romdir/intellivision\n\nCopy the required BIOS files exec.bin and grom.bin to $biosdir"
rp_module_licence="GPL2 http://spatula-city.org/%7Eim14u2c/intv/"
rp_module_section="sa"
rp_module_flags="dispmanx !odroid-n2"

function depends_jzintv() {
    getDepends libsdl1.2-dev
}

function sources_jzintv() {
    downloadAndExtract "$__archive_url/jzintv-20181225.zip" "$md_build"
    cd jzintv/src
    # don't build event_diag.rom/emu_ver.rom/joy_diag.rom/jlp_test.bin due to missing example/library files from zip
    sed -i '/^PROGS/,$d' {event,joy,jlp,util}/subMakefile
}

function build_jzintv() {
    mkdir -p jzintv/bin
    cd jzintv/src
    make clean
    make CC="gcc" CXX="g++" WARNXX="" OPT_FLAGS="$CFLAGS"
    md_ret_require="$md_build/jzintv/bin/jzintv"
}

function install_jzintv() {
    md_ret_files=(
        'jzintv/bin'
        'jzintv/src/COPYING.txt'
        'jzintv/src/COPYRIGHT.txt'
    )
}

function configure_jzintv() {
    mkRomDir "intellivision"

    if ! isPlatform "x11"; then
        setDispmanx "$md_id" 1
    fi
    if isPlatform "rpi"; then
	addEmulator 1 "$md_id" "intellivision" "$md_inst/bin/jzintv -p $biosdir -q %ROM%"
    elif isPlatform "odroid-xu"; then
    addEmulator 1 "$md_id" "intellivision" "$md_inst/bin/jzintv -z4 -f1 -p $biosdir -q %ROM%"
	elif isPlatform "rockpro64"; then
	addEmulator 1 "$md_id" "intellivision" "xinit $md_inst/bin/jzintv -z4 -f1 -p $biosdir -q %ROM%"
	fi
    addSystem "intellivision"
}
