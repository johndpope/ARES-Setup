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

rp_module_id="lr-yabasanshiro"
rp_module_desc="Sega Saturn Emulator"
rp_module_help="ROM Extensions: .iso .bin .zip\n\nCopy your Sega Saturn roms to $romdir/saturn\n\nCopy the required BIOS file saturn_bios_us.bin and saturn_bios_jp.bin to $biosdir"
rp_module_licence="https://github.com/devmiyax/yabause/blob/minimum_linux/yabause/COPYING"
rp_module_section="lr"
rp_module_flags=""

function sources_lr-yabasanshiro() {
    #gitPullOrClone "$md_build" https://github.com/devmiyax/yabause.git minimum_linux
    gitPullOrClone "$md_build" https://github.com/libretro/yabause.git yabasanshiro
    cd "$md_build/yabause"
}

function build_lr-yabasanshiro() {
    if isPlatform "odroid-n2"; then
        make -j5 -C yabause/src/libretro/ platform=odroid-n2
    elif isPlatform "odroid-xu"; then
        make  -C yabause/src/libretro/ platform=odroid BOARD="ODROID-XU3"
    elif isPlatform "rockpro64"; then       
        make -j5 -C yabause/src/libretro/ platform=rockpro64
    else
        exit
    fi
    md_ret_require="$md_build/yabause/src/libretro/yabasanshiro_libretro.so"
}

function install_lr-yabasanshiro() {
    md_ret_files=(
        'yabause/src/libretro/yabasanshiro_libretro.so'
    )
}

function configure_lr-yabasanshiro() {    
    mkRomDir "saturn"
    ensureSystemretroconfig "saturn"
    addEmulator 1 "$md_id" "saturn" "$md_inst/yabasanshiro_libretro.so"
    addSystem "saturn"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/$system/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/$system/"
    
    # set core options
    setRetroArchCoreOption "${dir_name}yabasanshiro_addon_cart" "4M_extended_ram"
    setRetroArchCoreOption "${dir_name}yabasanshiro_force_hle_bios" "disabled"
    setRetroArchCoreOption "${dir_name}yabasanshiro_frameskip" "disabled"
    setRetroArchCoreOption "${dir_name}yabasanshiro_multitap_port1" "disabled"
    setRetroArchCoreOption "${dir_name}yabasanshiro_multitap_port2" "disabled"
    setRetroArchCoreOption "${dir_name}yabasanshiro_resolution_mode" "2x"
    setRetroArchCoreOption "${dir_name}yabasanshiro_sh2coretype" "dynarec"
    setRetroArchCoreOption "${dir_name}yabasanshiro_videoformattype" "NTSC"
}
