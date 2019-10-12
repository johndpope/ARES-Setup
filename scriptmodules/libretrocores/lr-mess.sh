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

rp_module_id="lr-mess"
rp_module_desc="MESS emulator - MESS Port for libretro"
rp_module_help="see wiki for detailed explanation"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/mame/master/LICENSE.md"
rp_module_section="lr"

function depends_lr-mess() {
    depends_lr-mame
}

function sources_lr-mess() {
    gitPullOrClone "$md_build" https://github.com/libretro/mame.git
}

function build_lr-mess() {
    rpSwap on 5000
    local params=($(_get_params_lr-mame) SUBTARGET=mess)
    make clean
    make "${params[@]}" -j1
    rpSwap off
    md_ret_require="$md_build/mess_libretro.so"
}

function install_lr-mess() {
    md_ret_files=(
        'LICENSE.md'
        'mess_libretro.so'
        'README.md'
    )
}

function configure_lr-mess() {
    local module="$1"
    [[ -z "$module" ]] && module="mess_libretro.so"

    local system
    for system in arcadia cdimono1 crvision coleco scv pegasus atom bbcmicro electron apfimag lynx128k pv1000 adam cgenie gamepock gamate sorcerer fmtowns supracan mc10 vc4000 lviv alice aquarius vg5k radio86 mz2500 pockstat m5 gamecom tutor vector06 socrates  sv8000 apogee gmaster  ; do
        mkRomDir "$system"
        ensureSystemretroconfig "$system"
        addEmulator 0 "$md_id" "$system" "$md_inst/$module"
        addSystem "$system"
    done

    setRetroArchCoreOption "mame_softlists_enable" "enabled"
    setRetroArchCoreOption "mame_softlists_auto_media" "enabled"
    setRetroArchCoreOption "mame_boot_from_cli" "enabled"

    mkdir "$biosdir/mame"
    cp -rv "$md_build/hash" "$biosdir/mame/"
    chown -R $user:$user "$biosdir/mame"
}
