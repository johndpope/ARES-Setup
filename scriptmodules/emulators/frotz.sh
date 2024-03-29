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

rp_module_id="frotz"
rp_module_desc="Z-Machine Interpreter for Infocom games"
rp_module_help="ROM Extensions: .dat .zip .z1 .z2 .z3 .z4 .z5 .z6 .z7 .z8\n\nCopy your Infocom games to $romdir/zmachine"
rp_module_licence="GPL2 https://raw.githubusercontent.com/DavidGriffith/frotz/master/COPYING"
rp_module_section="sa"
rp_module_flags=" "

function _update_hook_frotz() {
    # to show as installed in RetroArena-setup 4.x
    hasPackage frotz && mkdir -p "$md_inst"
}

function install_bin_frotz() {
    aptInstall frotz
}

function remove_frotz() {
    aptRemove frotz
}

function game_data_frotz() {
    if [[ ! -f "$romdir/zmachine/zork1.dat" ]]; then
        cd "$__tmpdir"
        local file
        for file in zork1 zork2 zork3; do
            wget -nv -O "$file.zip" "$__archive_url/$file.zip"
            unzip -L -n "$file.zip" "data/$file.dat"
            mv "data/$file.dat" "$romdir/zmachine/"
            chown $user:$user "$romdir/zmachine/$file.dat"
            rm "$file.zip"
        done
        rmdir data
    fi
}

function configure_frotz() {
    mkRomDir "zmachine"

    # CON: to stop runcommand from redirecting stdout to log
    addEmulator 1 "$md_id" "zmachine" "CON:pushd $romdir/zmachine; frotz %ROM%; popd"
    addSystem "zmachine"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/$system/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/$system/"

    [[ "$md_mode" == "install" ]] && game_data_frotz
}
