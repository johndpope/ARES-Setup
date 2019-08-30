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

rp_module_id="devilutionx"
rp_module_desc="devilutionx a Diablo 1 engine"
rp_module_help="Place your diabdat.mpq inside the /home/pigaming/RetroArena/roms/ports/devilutionx folder"
rp_module_licence="The UNlicense https://raw.githubusercontent.com/diasurgical/devilutionX/master/LICENSE"
rp_module_section="prt"
rp_module_flags="!odroid-xu !odroid-n2"

function install_bin_devilutionx() {
    downloadAndExtract "https://github.com/Retro-Arena/ARES-Binaries/raw/master/stretch/odroid-xu/ports/devilutionx.tar.gz" "$md_inst" --strip-components 1
}

function configure_devilutionx() {
    mkRomDir "ports/$md_id"
    ln -sfn /home/pigaming/ARES/roms/ports/devilutionx/diabdat.mpq "$md_inst/diabdat.mpq"
    addPort "$md_id" "devilutionx" "devilutionx" "$md_inst/devilutionx"
    chown -R $user:$user "$md_inst"
    chmod -R 755 "$md_inst"
}
