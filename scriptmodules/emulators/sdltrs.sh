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

rp_module_id="sdltrs"
rp_module_desc="Radio Shack TRS-80 Model I/III/4/4P emulator"
rp_module_help="ROM Extension: .dsk\n\nCopy your TRS-80 games to $romdir/trs-80\n\nCopy the required BIOS file level2.rom, level3.rom, level4.rom or level4p.rom to $biosdir"
rp_module_section="sa"
rp_module_flags="dispmanx !odroid-n2"

function depends_sdltrs() {
    getDepends libsdl1.2-dev libxt-dev
}

function sources_sdltrs() {
    gitPullOrClone "$md_build" https://github.com/RetroPie/sdltrs.git
}

function build_sdltrs() {
    cd src/linux
    make clean
    make
    md_ret_require="$md_build/src/linux/sdltrs"
}

function install_sdltrs() {
    chmod 644 README
    md_ret_files=(
        'src/linux/sdltrs'
        'README'
    )
}

function configure_sdltrs() {
    mkRomDir "trs-80-1"
	mkRomDir "trs-80-3"
	mkRomDir "trs-80-4"

    local rom
    for rom in level2.rom level3.rom level4.rom level4p.rom; do
        ln -sf "$biosdir/$rom" "$md_inst/$rom"
    done
    if isPlatform "rpi"; then
    addEmulator 1 "$md_id-model1" "trs-80-1" "$md_inst/sdltrs -model 1 -romfile $biosdir/level2.rom -showled -diskdir $romdir/trs-80 -disk0 %ROM%"
    addEmulator 1 "$md_id-model3" "trs-80-3" "$md_inst/sdltrs -model 3 -romfile3 $biosdir/level3.rom -showled -diskdir $romdir/trs-80 -disk0 %ROM%"
    addEmulator 1 "$md_id-model4" "trs-80-4" "$md_inst/sdltrs -model 4 -romfile3 $biosdir/level4.rom -showled -diskdir $romdir/trs-80 -disk0 %ROM%"
    addEmulator 0 "$md_id-model4p" "trs-80-4" "$md_inst/sdltrs -model 4p -romfile4p $biosdir/level4p.rom -showled -diskdir $romdir/trs-80 -disk0 %ROM%"
	elif isPlatform "rockpro64" || isPlatform "odroid-xu"; then
	addEmulator 1 "$md_id-model1" "trs-80-1" "xinit $md_inst/sdltrs -model 1 -romfile $biosdir/level2.rom -showled -diskdir $romdir/trs-80 -disk0 %ROM%"
    addEmulator 1 "$md_id-model3" "trs-80-3" "xinit $md_inst/sdltrs -model 3 -romfile3 $biosdir/level3.rom -showled -diskdir $romdir/trs-80 -disk0 %ROM%"
    addEmulator 1 "$md_id-model4" "trs-80-4" "xinit $md_inst/sdltrs -model 4 -romfile3 $biosdir/level4.rom -showled -diskdir $romdir/trs-80 -disk0 %ROM%"
    addEmulator 0 "$md_id-model4p" "trs-80-4" "xinit $md_inst/sdltrs -model 4p -romfile4p $biosdir/level4p.rom -showled -diskdir $romdir/trs-80 -disk0 %ROM%"
	fi
    addSystem "trs-80-1"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/trs-80-1/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/trs-80-1/"
	addSystem "trs-80-3"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/trs-80-3/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/trs-80-3/"
	addSystem "trs-80-4"
	cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/trs-80-4/"
    cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/trs-80-4/"
}
