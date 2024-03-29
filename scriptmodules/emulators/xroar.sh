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

rp_module_id="xroar"
rp_module_desc="Dragon / CoCo emulator XRoar"
rp_module_help="ROM Extensions: .cas .wav .bas .asc .dmk .jvc .os9 .dsk .vdk .rom .ccc .sna\n\nCopy your Dragon roms to $romdir/dragon32\n\nCopy your CoCo games to $romdir/coco\n\nCopy the required BIOS files d32.rom (Dragon 32) and bas13.rom (CoCo) to $biosdir"
rp_module_licence="GPL2 http://www.6809.org.uk/xroar/"
rp_module_section="sa"
rp_module_flags=" "

function depends_xroar() {
    getDepends libsdl2-dev automake
}

function sources_xroar() {
    gitPullOrClone "$md_build" http://www.6809.org.uk/git/xroar.git 0.35.4 "" 0
}

function build_xroar() {
    local params=(--without-gtk2 --without-gtkgl)
    if ! isPlatform "x11"; then
       params+=(--without-pulse)
    fi
    ./autogen.sh
    ./configure --prefix="$md_inst" "${params[@]}"
    make clean
    make
    md_ret_require="$md_build/src/xroar"
}

function install_xroar() {
    make install
}

function configure_xroar() {
    mkRomDir "dragon32"
    mkRomDir "coco"

    mkdir -p "$md_inst/share/xroar"
    ln -snf "$biosdir" "$md_inst/share/xroar/roms"

    local params=(-fs)
    ! isPlatform "x11" &&  params+=(-vo sdlyuv --ccr simple)
	if isPlatform "rpi" || isPlatform "odroid-xu"; then
    addEmulator 1 "$md_id-dragon32" "dragon32" "$md_inst/bin/xroar ${params[*]} -machine dragon32 -run %ROM%"
    addEmulator 1 "$md_id-cocous" "coco" "$md_inst/bin/xroar ${params[*]} -machine cocous -run %ROM%"
    addEmulator 0 "$md_id-coco" "coco" "$md_inst/bin/xroar ${params[*]} -machine coco -run %ROM%"
	elif isPlatform "rockpro64"; then
	addEmulator 1 "$md_id-dragon32" "dragon32" "xinit $md_inst/bin/xroar ${params[*]} -machine dragon32 -run %ROM%"
    addEmulator 1 "$md_id-cocous" "coco" "xinit $md_inst/bin/xroar ${params[*]} -machine cocous -run %ROM%"
    addEmulator 0 "$md_id-coco" "coco" "xinit $md_inst/bin/xroar ${params[*]} -machine coco -run %ROM%"
	fi
    addSystem "dragon32"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/dragon32/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/dragon32/"
    addSystem "coco"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/coco/"
cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/coco/"
}
