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

rp_module_id="lincity-ng"
rp_module_desc="lincity-ng - Open Source City Building Game"
rp_module_licence="GPL2 https://raw.githubusercontent.com/lincity-ng/lincity-ng/master/COPYING"
rp_module_section="prt"
rp_module_flags="!mali"

function _update_hook_lincity-ng() {
    # to show as installed in retropie-setup 4.x
    hasPackage lincity-ng && mkdir -p "$md_inst"
}

function depends_lincity-ng() {
    ! isPlatform "x11" && getDepends xorg
}

function install_bin_lincity-ng() {
    aptInstall lincity-ng
}

function remove_lincity-ng() {
    aptRemove lincity-ng
}

function configure_lincity-ng() {
    if isPlatform "x11"; then
        addPort "$md_id" "lincity-ng" "LinCity-NG" "/usr/games/lincity-ng"
    else
        addPort "$md_id" "lincity-ng" "LinCity-NG" "xinit /usr/games/lincity-ng"
    fi
    moveConfigDir "$home/.lincity-ng" "$md_conf_root/lincity-ng"
    # fix for wrong config location
    if [[ -d "/lincity-ng" ]]; then
        cp -R /lincity-ng "$md_conf_root/"
        rm -rf /lincity-ng
        chown $user:$user "$md_conf_root/lincity-ng"
    fi
}
