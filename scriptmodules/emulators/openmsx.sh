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

rp_module_id="openmsx"
rp_module_desc="MSX emulator OpenMSX"
rp_module_help="ROM Extensions: .rom .mx1 .mx2 .col .dsk .zip\n\nCopy your MSX/MSX2 games to $romdir/msx"
rp_module_licence="GPL2 https://raw.githubusercontent.com/openMSX/openMSX/master/doc/GPL.txt"
rp_module_section="sa"
rp_module_flags=""

function depends_openmsx() {
    local depends=(libsdl2-dev libsdl2-ttf-dev libao-dev libogg-dev libtheora-dev libxml2-dev libvorbis-dev tcl-dev libasound2-dev)
    isPlatform "x11" && depends+=(libglew-dev)
    getDepends "${depends[@]}"
}

function sources_openmsx() {
    local branch"master"
    local commit="77b336886adac24737818e5e95557624019cc146"
    gitPullOrClone "$md_build" https://github.com/openMSX/openMSX.git  "$branch" "$commit"
    sed -i "s|INSTALL_BASE:=/opt/openMSX|INSTALL_BASE:=$md_inst|" build/custom.mk
    sed -i "s|SYMLINK_FOR_BINARY:=true|SYMLINK_FOR_BINARY:=false|" build/custom.mk
}

function build_openmsx() {
    rpSwap on 2000
    ./configure
    make clean
    make
    rpSwap off
    md_ret_require="$md_build/derived/openmsx"
}

function install_openmsx() {
    make install
    mkdir -p "$md_inst/share/systemroms/"
    downloadAndExtract "$__archive_url/openmsxroms.tar.gz" "$md_inst/share/systemroms/"
}


function configure_openmsx() {
    mkRomDir "msx"
    mkRomDir "msx2"
	mkRomDir "msx2p"
	mkRomDir "msxtr"
	mkRomDir "spectravideo"
    mkRomDir "coleco"

    addEmulator 0 "$md_id" "msx" "$md_inst/bin/openmsx %ROM%"
    addSystem "msx"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/msx/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/msx/"
    addEmulator 0 "$md_id" "msx2" "$md_inst/bin/openmsx %ROM%"
    addSystem "msx2"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/msx2/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/msx2/"
	addEmulator 0 "$md_id" "msx2p" "$md_inst/bin/openmsx %ROM%"
    addSystem "msx2p"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/msx2p/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/msx2p/"
	addEmulator 0 "$md_id" "msxtr" "$md_inst/bin/openmsx %ROM%"
    addSystem "msxtr"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/msxtr/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/msxtr/"
	addEmulator 0 "$md_id" "spectravideo" "$md_inst/bin/openmsx %ROM%"
    addSystem "spectravideo"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/spectravideo/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/spectravideo/"
    addEmulator 0 "$md_id" "coleco" "$md_inst/bin/openmsx -machine ColecoVision_SGM %ROM%"
    addSystem "coleco"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/coleco/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/coleco/"
    ln -sfn "$biosdir/COLECO.ROM" "$md_inst/share/systemroms/COLECO.ROM"
}
