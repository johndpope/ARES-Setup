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

rp_module_id="openbor"
rp_module_desc="OpenBOR (v6510) - Beat 'em Up Game Engine"
rp_module_help="Place your pak files in $romdir/openbor and launch from ES.\n\nUse a keyboard to initially configure a gamepad."
rp_module_licence="BSD https://raw.githubusercontent.com/crcerror/OpenBOR-Raspberry/master/LICENSE"
rp_module_section="sa"
rp_module_flags=""

function depends_openbor() {
    getDepends libsdl2-gfx-dev libvorbisidec-dev libvpx-dev libogg-dev libsdl2-gfx-1.0-0 libvorbisidec1
}

function sources_openbor() {
    gitPullOrClone "$md_build" https://github.com/crcerror/OpenBOR-Raspberry.git
}

function build_openbor() {
    local params=()
    ! isPlatform "x11" && params+=(BUILD_PANDORA=1)
    make clean-all BUILD_PANDORA=1
    isPlatform "odroid-n2" && sed -i -e 's:-marm -mfloat-abi=hard ::g' "$md_build/patch/latest_build.diff"
    isPlatform "rockpro64" && sed -i -e 's:-marm -mfloat-abi=hard ::g' "$md_build/patch/latest_build.diff"
    patch -p0 -i ./patch/latest_build.diff
    make "${params[@]}"
    md_ret_require="$md_build/OpenBOR"
    wget -q --show-progress "http://raw.githubusercontent.com/crcerror/OpenBOR-63xx-RetroPie-openbeta/master/libGL-binary/libGL.so.1.gz"
    gunzip -f libGL.so.1.gz
}

function install_openbor() {
    md_ret_files=(
       'OpenBOR'
       'libGL.so.1'
    )
}

function configure_openbor() {
    mkRomDir "openbor"
    mkUserDir "$configdir/openbor/ScreenShots"
    mkUserDir "$configdir/openbor/Saves"
    addSystem "openbor"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/$system/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/$system/"
    addEmulator 1 "$md_id" "openbor" "pushd $md_inst; $md_inst/openbor %ROM%; popd"
    mv "$md_inst/OpenBOR" "$md_inst/openbor"
    ln -snf "/dev/shm" "$md_inst/Logs"
    ln -snf "$datadir/roms/openbor" "$md_inst/Paks"
    ln -snf "$configdir/openbor/ScreenShots" "$md_inst/ScreenShots"
    ln -snf "$configdir/openbor/Saves" "$md_inst/Saves"
}
