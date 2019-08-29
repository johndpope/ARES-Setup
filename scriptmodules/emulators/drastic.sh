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

rp_module_id="drastic"
rp_module_desc="NDS emu - DraStic"
rp_module_help="ROM Extensions: .nds .zip\n\nCopy your Nintendo DS roms to $romdir/nds"
rp_module_licence="PROP"
rp_module_section="sa"
rp_module_flags=""

function install_bin_drastic() {
    downloadAndExtract "$ __binary_url/drastic.tar.gz" "$md_inst" 1
    patchVendorGraphics "$md_inst/drastic"
}

function configure_drastic() {
    mkRomDir "nds"

    # wrong permissions on game_database.xml
    chmod 644 "$md_inst/game_database.xml"

    mkUserDir "$md_conf_root/nds/drastic"
    mkUserDir "$md_conf_root/nds/drastic/system"

    local file
    for file in game_database.xml system/drastic_bios_arm7.bin system/drastic_bios_arm9.bin usrcheat.dat drastic_logo_0.raw drastic_logo_1.raw; do
        ln -sfv "$md_inst/$file" "$md_conf_root/nds/drastic/$file"
    done

    addEmulator 1 "$md_id" "nds" "pushd $md_conf_root/nds/drastic; $md_inst/drastic %ROM%; popd"
    addSystem "nds"
}
