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

rp_module_id="zesarux"
rp_module_desc="ZX Spectrum emulator ZEsarUX"
rp_module_help="ROM Extensions: .sna .szx .z80 .tap .tzx .gz .udi .mgt .img .trd .scl .dsk .zip\n\nCopy your ZX Spectrum games to $romdir/zxspectrum"
rp_module_licence="GPL3 https://sourceforge.net/p/zesarux/code/ci/master/tree/LICENSE"
rp_module_section="sa"
rp_module_flags="dispmanx !odroid-n2"


function depends_zesarux() {
    local depends=(libssl-dev libpthread-stubs0-dev libsdl1.2-dev libasound2-dev)
    isPlatform "x11" && depends+=(libpulse-dev)
    getDepends "${depends[@]}"
}

function sources_zesarux() {
   gitPullOrClone "$md_build" https://github.com/chernandezba/zesarux.git 8.0
}

function build_zesarux() {
    cd src
    local params=()
	isPlatform "videocore" && params+=(--enable-raspberry)
    ! isPlatform "x11" && params+=(--disable-pulse)
    isPlatform "mali" || isPlatform "kms" && params+=(--enable-sdl2 )
    ./configure --prefix "$md_inst" "${params[@]}"
    make clean
    make
    md_ret_require="$md_build/src/zesarux"
}

function install_zesarux() {
    cd src
    make install
}


function configure_zesarux() {
    mkRomDir "zxspectrum"
    mkRomDir "amstradcpc"
    mkRomDir "samcoupe"
    mkRomDir "zx81"
    mkRomDir "jupiter-ace"
    mkRomDir "ql"

    mkUserDir "$md_conf_root/zxspectrum"

    cat > "$romdir/zxspectrum/+Start ZEsarUX.sh" << _EOF_
#!/bin/bash
"$md_inst/bin/zesarux" "\$@"
_EOF_
    chmod +x "$romdir/zxspectrum/+Start ZEsarUX.sh"
    chown $user:$user "$romdir/zxspectrum/+Start ZEsarUX.sh"

    moveConfigFile "$home/.zesaruxrc" "$md_conf_root/zxspectrum/.zesaruxrc"

    local ao="sdl"
    isPlatform "x11" && ao="pulse"
    local config="$(mktemp)"

    cat > "$config" << _EOF_
;ZEsarUX sample configuration file
;
;Lines beginning with ; or # are ignored

;Run zesarux with --help or --experthelp to see all the options
--disableborder
--disablefooter
--vo sdl
--ao $ao
--hidemousepointer
--fullscreen

--smartloadpath $romdir/zxspectrum

--joystickemulated Kempston

;Remap Fire Event. Uncomment and amend if you wish to change the default button 3.
;--joystickevent 3 Fire
;Remap On-screen keyboard. Uncomment and amend if you wish to change the default button 5.
;--joystickevent 5 Osdkeyboard
_EOF_

    copyDefaultConfig "$config" "$md_conf_root/zxspectrum/.zesaruxrc"
    rm "$config"

    setDispmanx "$md_id" 1

    addEmulator 1 "$md_id" "zxspectrum" "bash $romdir/zxspectrum/+Start\ ZEsarUX.sh %ROM%"

    addEmulator 1 "$md_id" "samcoupe" "bash $romdir/zxspectrum/+Start\ ZEsarUX.sh --machine sam %ROM%"
    addEmulator 1 "$md_id" "amstradcpc" "bash $romdir/zxspectrum/+Start\ ZEsarUX.sh --machine CPC464 %ROM%"
    addEmulator 1 "$md_id" "zx81" "bash $romdir/zxspectrum/+Start\ ZEsarUX.sh --machine ZX81 %ROM%"
    addEmulator 1 "$md_id" "jupiter-ace" "bash $romdir/zxspectrum/+Start\ ZEsarUX.sh --machine ACE %ROM%"
    addEmulator 1 "$md_id" "ql" "bash $romdir/zxspectrum/+Start\ ZEsarUX.sh --machine QL %ROM%"
    addSystem "zxspectrum"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/zxspectrum/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/zxspectrum/"
    addSystem "samcoupe"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/samcoupe/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/samcoupe/"
    addSystem "amstradcpc"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/amstradcpc/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/amstradcpc/"
    addSystem "zx81"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/zx81/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/zx81/"
    addSystem "jupiter-ace"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/jupiter-ace/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/jupiter-ace/"
    addSystem "ql"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/ql/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/ql/"
}
