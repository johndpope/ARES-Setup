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

rp_module_id="srb2kart"
rp_module_desc="Sonic Robo Blast 2 Kart - 3D Sonic the Hedgehog fan-game based on Sonic Robo Blast 2 built using a modified version of the Doom Legacy source port of Doom"
rp_module_licence="GPL2 https://raw.githubusercontent.com/STJr/Kart-Public/master/LICENSE"
rp_module_section="prt"

function depends_srb2kart() {
    getDepends cmake libsdl2-dev libsdl2-mixer-dev
}

function sources_srb2kart() {
    gitPullOrClone "$md_build" https://github.com/STJr/Kart-Public.git
    downloadAndExtract "https://github.com/Retro-Arena/binaries/raw/master/common/srb2kart-assets1.tar.gz" "$md_build"
    downloadAndExtract "https://github.com/Retro-Arena/binaries/raw/master/common/srb2kart-assets2.tar.gz" "$md_build"
    downloadAndExtract "https://github.com/Retro-Arena/binaries/raw/master/common/srb2kart-assets3.tar.gz" "$md_build"
}

function build_srb2kart() {
    mkdir build
    cd build
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$md_inst"
    make
    md_ret_require="$md_build/build/bin/srb2kart"
}

function install_srb2kart() {
    # copy and dereference, so we get a srb2kart binary rather than a symlink to srb2kart-version
    cp -L 'build/bin/srb2kart' "$md_inst/srb2kart"
    md_ret_files=(
        'assets/installer/bonuschars.kart'
        'assets/installer/chars.kart'
        'assets/installer/gfx.kart'
        'assets/installer/maps.kart'
        'assets/installer/music.kart'
        'assets/installer/patch.kart'
        'assets/installer/sounds.kart'
        'assets/installer/textures.kart'
        'assets/installer/srb2.srb'
    )
}

#function install_bin_srb2kart() {
    #downloadAndExtract "$__gitbins_url/srb2kart.tar.gz" "$md_inst" 1
    #downloadAndExtract "$__gitbins_url/srb2karta.tar.gz" "$md_inst" 1
#}

function configure_srb2kart() {
    addPort "$md_id" "srb2kart" "Sonic Robo Blast 2 Kart" "pushd $md_inst; ./srb2kart; popd"
    moveConfigDir "$home/.srb2kart"  "$md_conf_root/$md_id"
}
