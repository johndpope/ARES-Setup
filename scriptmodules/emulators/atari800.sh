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

rp_module_id="atari800"
rp_module_desc="Atari 8-bit/800/5200 emulator"
rp_module_help="ROM Extensions: .a52 .bas .bin .car .xex .atr .xfd .dcm .atr.gz .xfd.gz\n\nCopy your Atari800 games to $romdir/atari800\n\nCopy your Atari 5200 roms to $romdir/atari5200 You need to copy the Atari 800/5200 BIOS files (5200.ROM, ATARIBAS.ROM, ATARIOSB.ROM and ATARIXL.ROM) to the folder $biosdir and then on first launch configure it to scan that folder for roms (F1 -> Emulator Configuration -> System Rom Settings)"
rp_module_licence="GPL2 https://sourceforge.net/p/atari800/source/ci/master/tree/COPYING"
rp_module_section="sa"
rp_module_flags="!odroid-n2"

function depends_atari800() {
    local depends=(libsdl1.2-dev autoconf zlib1g-dev libpng-dev)
    isPlatform "rpi" && depends+=(libraspberrypi-dev)
    getDepends "${depends[@]}"
}

function sources_atari800() {
    downloadAndExtract "$__archive_url/atari800-4.0.0.tar.gz" "$md_build" --strip-components 1
    if isPlatform "rpi"; then
        applyPatch "$md_data/01_rpi_fixes.diff"
    fi
}

function build_atari800() {
    cd src
    cp  /usr/share/misc/config.guess "$md_build/src/"
    cp /usr/share/misc/config.sub "$md_build/src/"
    autoreconf -v
    params=()
    isPlatform "rpi" && params+=(--target=rpi)
    ./configure --prefix="$md_inst" ${params[@]}
    make clean
    make
    md_ret_require="$md_build/src/atari800"
}

function install_atari800() {
    cd src
    make install
}

function configure_atari800() {
    mkRomDir "atari800"
    mkRomDir "atari5200"

    mkUserDir "$md_conf_root/atari800"

    # move old config if exists to new location
    if [[ -f "$md_conf_root/atari800.cfg" ]]; then
        mv "$md_conf_root/atari800.cfg" "$md_conf_root/atari800/atari800.cfg"
	fi
    moveConfigFile "$home/.atari800.cfg" "$md_conf_root/atari800/atari800.cfg"
	cp "$scriptdir/configs/atari800/atari800.cfg" "$md_conf_root/atari800"
	if isPlatform "rpi" || isPlatform "odroid-xu"; then
    addEmulator 1 "atari800" "atari800" "$md_inst/bin/atari800 %ROM%"
    addEmulator 1 "atari800" "atari5200" "$md_inst/bin/atari800 %ROM%"
	elif isPlatform "rockpro64"; then
	addEmulator 1 "atari800" "atari800" "xinit $md_inst/bin/atari800 %ROM%"
    addEmulator 1 "atari800" "atari5200" "xinit $md_inst/bin/atari800 %ROM%"
	fi
    addSystem "atari800"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/atari800/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/atari800/"
    addSystem "atari5200"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/atari5200/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/atari5200/"
}
