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

rp_module_id="xm7"
rp_module_desc="Fujitsu FM-7 series emulator"
rp_module_help="ROM Extensions: .d77 .t77 .d88 .2d \n\nCopy your FM-7 games to to $romdir/xm7\n\nCopy bios files DICROM.ROM, EXTSUB.ROM, FBASIC30.ROM, INITIATE.ROM, KANJI1.ROM, KANJI2.ROM, SUBSYS_A.ROM, SUBSYS_B.ROM, SUBSYSCG.ROM, SUBSYS_C.ROM, fddseek.wav, relayoff.wav and relay_on.wav to $biosdir/xm7"
rp_module_licence="NONCOM https://raw.githubusercontent.com/nakatamaho/XM7-for-SDL/master/Doc/mess/license.txt"
rp_module_section="sa"
rp_module_flags="dispmanx !odroid-n2"

function depends_xm7() {
    getDepends libjpeg-dev libsdl1.2-dev libsdl-mixer1.2-dev libtool libpng-dev libuim-dev libfreetype6-dev libfontconfig1-dev gawk fonts-takao libxinerama-dev libx11-dev imagemagick
}

function sources_xm7() {
    gitPullOrClone "$md_build" https://github.com/nakatamaho/XM7-for-SDL.git
    mkdir -p "$md_build/agar"
    downloadAndExtract "http://stable.hypertriton.com/agar/agar-1.5.0.tar.gz" "$md_build/agar" --strip-components 1
    # _BSD_SOURCE is deprecated and will throw an error during configure
    sed -i "s/_BSD_SOURCE/_DEFAULT_SOURCE/g" "$md_build/agar/configure"
    # needs libx11 to link
    applyPatch "$md_data/01_fix_build.diff"
}

function build_xm7() {
    cd agar
    cp /usr/share/misc/config.guess "$md_build/agar/mk/"
    cp /usr/share/misc/config.sub "$md_build/agar/mk/"
    ./configure --disable-shared --prefix="$md_build/libagar"
    make -j1 depend all install
    cd "$md_build"
    mkdir linux-sdl/build
    cd linux-sdl/build
    cmake -DCMAKE_CXX_FLAGS="-DSHAREDIR='\"${md_inst}/share/xm7\"'" -DCMAKE_INSTALL_PREFIX:PATH="$md_inst" -DCMAKE_BUILD_TYPE=Release -DUSE_OPENCL=No -DUSE_OPENGL=No -DWITH_LIBAGAR_PREFIX="$md_build/libagar" -DWITH_AGAR_STATIC=yes ..
    make
    md_ret_require="$md_build/linux-sdl/build/sdl/xm7"
}

function install_xm7() {
    cd linux-sdl/build
    make install
}

function configure_xm7() {
    mkRomDir "fm7"

    moveConfigDir "$home/.xm7" "$md_conf_root/fm7"

    mkUserDir "$biosdir/fm7"

    local bios
    for bios in DICROM.ROM EXTSUB.ROM FBASIC30.ROM INITIATE.ROM KANJI1.ROM KANJI2.ROM SUBSYS_A.ROM SUBSYS_B.ROM SUBSYSCG.ROM SUBSYS_C.ROM fddseek.wav relayoff.wav relay_on.wav; do
        ln -sf "$biosdir/fm7/$bios" "$md_conf_root/fm7/$bios"
    done
    if isPlatform "rpi" || isPlatform "odroid-xu"; then
    addEmulator 1 "$md_id" "fm7" "$md_inst/bin/xm7 %ROM%"
	elif isPlatform "rockpro64"; then
	addEmulator 1 "$md_id" "fm7" "xinit $md_inst/bin/xm7 %ROM%"
	fi
    addSystem "fm7"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/$system/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/$system/"
}
