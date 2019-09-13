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

rp_module_id="lr-mupen64plus-next"
rp_module_desc="N64 emulator - Mupen64Plus + GLideN64 for libretro (next version)"
rp_module_help="ROM Extensions: .z64 .n64 .v64\n\nCopy your N64 roms to $romdir/n64"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/mupen64plus-libretro-nx/GLideN64/LICENSE"
rp_module_section="lr"
rp_module_flags="!armv6"

function depends_lr-mupen64plus-next() {
    local depends=(flex bison libpng-dev)
    isPlatform "x11" && depends+=(libglew-dev libglu1-mesa-dev)
    isPlatform "x86" && depends+=(nasm)
    isPlatform "videocore" && depends+=(libraspberrypi-dev)
    isPlatform "mesa" && depends+=(libgles2-mesa-dev)
    getDepends "${depends[@]}"
}

function sources_lr-mupen64plus-next() {
    gitPullOrClone "$md_build" https://github.com/libretro/mupen64plus-libretro-nx.git develop

    # HACK: force EGL detection on FKMS
    isPlatform "mesa" && applyPatch "$md_data/0001-force-egl.patch"
}

function build_lr-mupen64plus-next() {
    local params=()
    if isPlatform "videocore"; then
        params+=(platform="$__platform")
    elif isPlatform "mesa"; then
        params+=(platform="$__platform-mesa")
    elif isPlatform "mali"; then
        params+=(platform="odroid")
    else
        isPlatform "odroid-xu" && params+=(platform=odroid BOARD=ODROID-XU)
		isPlatform "odroid-n2" && params+=(platform=odroid64 BOARD=N2)
		isPlatform "rockpro64" && params+=(platform=RK3399)
		isPlatform "arm" && params+=(WITH_DYNAREC=arm)
        isPlatform "neon" && params+=(HAVE_NEON=1)
        isPlatform "gles" && params+=(FORCE_GLES=1)
        isPlatform "kms" && params+=(FORCE_GLES3=1)
    fi
    # use a custom core name to avoid core option name clashes with lr-mupen64plus
    params+=(CORE_NAME=mupen64plus-next)
    make "${params[@]}" clean
    make "${params[@]}"
    md_ret_require="$md_build/mupen64plus_next_libretro.so"
}

function install_lr-mupen64plus-next() {
    md_ret_files=(
        'mupen64plus_next_libretro.so'
        'LICENSE'
        'README.md'
    )
}

function configure_lr-mupen64plus-next() {
    mkRomDir "n64"
    ensureSystemretroconfig "n64"

    addEmulator 0 "$md_id" "n64" "$md_inst/mupen64plus_next_libretro.so"
    addSystem "n64"
}
