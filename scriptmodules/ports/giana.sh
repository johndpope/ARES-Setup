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

rp_module_id="giana"
rp_module_desc="Giana's Return"
rp_module_section="prt"
rp_module_flags="!x86 !mali !kms"

function depends_giana() {
    getDepends libsdl1.2-dev libsdl-mixer1.2-dev libraspberrypi-dev
}

function install_bin_giana() {
    downloadAndExtract "http://www.retroguru.com/gianas-return/gianas-return-v.latest-raspberrypi.zip" "$md_inst"
    patchVendorGraphics "$md_inst/giana_rpi"
}

function configure_giana() {
    moveConfigDir "$home/.giana" "$md_conf_root/giana"

    addPort "$md_id" "giana" "Giana's Return" "pushd $md_inst; $md_inst/giana_rpi; popd"

    chmod +x "$md_inst/giana_rpi"
}
