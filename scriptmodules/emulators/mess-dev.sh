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

rp_module_id="mess"
rp_module_desc="mess emulator"
rp_module_help="ROM Extensions: .zip .7z\n\nCopy your mess roms to either $romdir/mame or\n$romdir/arcade"
rp_module_licence="GPL2 https://github.com/mamedev/mame/blob/master/LICENSE.md"
rp_module_section="sa"
rp_module_flags="!armv6"

function _latest_ver_mess() {
    wget -qO- https://api.github.com/repos/mamedev/mame/releases/latest | grep -m 1 tag_name | cut -d\" -f4
}

function _get_binary_name_mess() {
    # The MESS executable on 64-bit systems is called mess64 instead of mess. Rename it back to mess.
    if isPlatform "64bit"; then
        echo 'mess64'
    else
        echo 'mess'
    fi
}

function depends_mess() {
    if compareVersions $__gcc_version lt 6.0.0; then
        md_ret_errors+=("Sorry, you need an OS with gcc 6.0 or newer to compile mess")
        return 1
    fi

    # Additional libraries required for running
    getDepends libsdl2-ttf-2.0-0

    # Additional libraries required for compilation
    getDepends libfontconfig1-dev qt5-default libsdl2-ttf-dev libxinerama-dev
}

function sources_mess() {
    gitPullOrClone "$md_build" https://github.com/mamedev/mame.git "$(_latest_ver_mess)"
}

function build_mess() {
    # More memory is required for x86 platforms
    if isPlatform "x86"; then
        rpSwap on 8192
    else
        rpSwap on 5120
    fi

    # Compile MESS
    make SUBTARGET=mess ARCHOPTS=-U_FORTIFY_SOURCE NOWERROR=1 -j1

    if isPlatform "64bit"; then
        strip mess64
    else
        strip mess
    fi

    rpSwap off
    md_ret_require="$md_build/$(_get_binary_name_${md_id})"
}

function install_mess() {
    md_ret_files=(
        'artwork'
        'bgfx'
        'ctrlr'
        'docs'
        'hash'
        'hlsl'
        'ini'
        'language'
        "$(_get_binary_name_${md_id})"
        'nl_examples'
        'plugins'
        'roms'
        'samples'
        'uismall.bdf'
        'LICENSE.md'
    )
}

function configure_mess() {
    local system
    for system in adam advision alice apfimag apogee aquarius arcadia astrocade atom bbcmicro cdimono1 cgenie coleco crvision electron exl100 fmtowns gamecom gmaster gamate gamepock gp32 hec2hrx lviv lynx128k m5  mc10 megaduck microvsn mz2500 pegasus pockstat pv1000 pv2000 radio86 scv socrates studio2 supervision sv8000 tutor vc4000 vector06 vg5k; do 
	    mkRomDir "$system"
		cp -r "$scriptdir/configs/all/retrofe/medium_artwork" "$romdir/$system/"
        cp -r "$scriptdir/configs/all/retrofe/system_artwork" "$romdir/$system/"
		        
    done   

    moveConfigDir "$home/.mess" "$md_conf_root/$system"

    # Create required MESS directories underneath the ROM directory
    if [[ "$md_mode" == "install" ]]; then
        local mess_sub_dir
        for mess_sub_dir in artwork cfg comments diff inp nvram samples scores snap sta; do
            mkRomDir "$system/$mess_sub_dir"
        done
    fi

    # Create a BIOS directory, where people will be able to store their BIOS files, separate from ROMs
    mkUserDir "$biosdir/$system"
    chown $user:$user "$biosdir/$system"

    # Create a new INI file if one does not already exist
    if [[ "$md_mode" == "install" && ! -f "$md_conf_root/$system/mess.ini" ]]; then
        pushd "$md_conf_root/$system/"
        "$md_inst/$(_get_binary_name_${md_id})" -createconfig
        popd

        iniConfig " " "" "$md_conf_root/$system/mess.ini"
        iniSet "rompath"            "$romdir/$system;$romdir/arcade;$biosdir/$system"
        iniSet "hashpath"           "$md_inst/hash"
        iniSet "samplepath"         "$romdir/$system/samples;$romdir/arcade/samples"
        iniSet "artpath"            "$romdir/$system/artwork;$romdir/arcade/artwork"
        iniSet "ctrlrpath"          "$md_inst/ctrlr"
        iniSet "pluginspath"        "$md_inst/plugins"
        iniSet "languagepath"       "$md_inst/language"

        iniSet "cfg_directory"      "$romdir/$system/cfg"
        iniSet "nvram_directory"    "$romdir/$system/nvram"
        iniSet "input_directory"    "$romdir/$system/inp"
        iniSet "state_directory"    "$romdir/$system/sta"
        iniSet "snapshot_directory" "$romdir/$system/snap"
        iniSet "diff_directory"     "$romdir/$system/diff"
        iniSet "comment_directory"  "$romdir/$system/comments"

        iniSet "skip_gameinfo" "1"
        iniSet "plugin" "hiscore"
        iniSet "samplerate" "44100"

        iniConfig " " "" "$md_conf_root/$system/ui.ini"
        iniSet "scores_directory" "$romdir/$system/scores"

        iniConfig " " "" "$md_conf_root/$system/plugin.ini"
        iniSet "hiscore" "1"

        iniConfig " " "" "$md_conf_root/$system/hiscore.ini"
        iniSet "hi_path" "$romdir/$system/scores"

        chown -R $user:$user "$md_conf_root/$system"
        chmod a+r "$md_conf_root/$system/mess.ini"
    fi

    local binary_name="$(_get_binary_name_${md_id})"
    #Cartridge Only
	
	addEmulator 0 "$md_id" "advision" "$md_inst/mess advision -cart %BASENAME%"
	addEmulator 0 "$md_id" "arcadia" "$md_inst/mess arcadia  -cart %BASENAME%"
	addEmulator 0 "$md_id" "astrocade" "$md_inst/mess astrocde -cart %BASENAME%"
	addEmulator 0 "$md_id" "channelf" "$md_inst/mess channelf  -cart %BASENAME%"
	addEmulator 0 "$md_id" "megaduck" "$md_inst/mess megaduck  -cart %BASENAME%"
	addEmulator 0 "$md_id" "supervision" "$md_inst/mess svision -cart %BASENAME%"
	addEmulator 0 "$md_id" "studio2" "$md_inst/mess studio2 -cart %BASENAME%"
	addEmulator 0 "$md_id" "creativision" "$md_inst/mess crvision -cart %BASENAME%"
	addEmulator 0 "$md_id" "gamecom" "$md_inst/mess gamecom -cart1 %BASENAME%"
	addEmulator 0 "$md_id" "gmaster" "$md_inst/mess gmaster -cart %BASENAME%"
	addEmulator 0 "$md_id" "gamate" "$md_inst/mess gamate -cart %BASENAME%"
	addEmulator 0 "$md_id" "gamepock" "$md_inst/mess gamepock -cart %BASENAME%"
	addEmulator 0 "$md_id" "microvsn" "$md_inst/mess microvsn -cart %BASENAME%"
	addEmulator 0 "$md_id" "pv1000" "$md_inst/mess pv1000 -cart %BASENAME%"
	addEmulator 0 "$md_id" "scv" "$md_inst/mess scv -cart %BASENAME%"
	addEmulator 0 "$md_id" "socrates" "$md_inst/mess socrates -cart %BASENAME%"
	addEmulator 0 "$md_id" "sv8000" "$md_inst/mess sv8000 -cart %BASENAME%"
	addEmulator 0 "$md_id" "vc4000" "$md_inst/mess vc4000 -cart %BASENAME%"
	addEmulator 0 "$md_id" "pockstat" "$md_inst/mess pockstat -cart %BASENAME%"
	addEmulator 0 "$md_id" "supracan" "$md_inst/mess supracan -cart %BASENAME%"
	
	# Cassette Only
	
	addEmulator 0 "$md_id" "electron" "$md_inst/mess electron -cass %BASENAME%"
	addEmulator 0 "$md_id" "alice" "$md_inst/mess alice -cass %BASENAME%"
	addEmulator 0 "$md_id" "apogee" "$md_inst/mess electron -cass %BASENAME%"
	addEmulator 0 "$md_id" "mc10" "$md_inst/mess mc10 -cass %BASENAME%"
	addEmulator 0 "$md_id" "hec2hrx" "$md_inst/mess hec2hrx -cass %BASENAME%"
	addEmulator 0 "$md_id" "vg5k" "$md_inst/mess vg5k -cass %BASENAME%"
	addEmulator 0 "$md_id" "lviv" "$md_inst/mess lviv -cass %BASENAME%"
	
	#Floppy Only
	
	addEmulator 0 "$md_id" "mz2500" "$md_inst/mess mz2500 -flop1 %BASENAME%"
	
	#Multiple Media Options
	# Cart & Cass
	
	addEmulator 0 "$md_id" "apfimag" "$md_inst/mess apfimag -cart %BASENAME%"
	addEmulator 0 "$md_id" "apfimag" "$md_inst/mess apfimag -cass %BASENAME%"
	addEmulator 0 "$md_id" "aquarius" "$md_inst/mess aquarius -cart %BASENAME%"
	addEmulator 0 "$md_id" "aquarius" "$md_inst/mess aquarius -cass %BASENAME%"
	addEmulator 0 "$md_id" "radio86" "$md_inst/mess radio86 -cart %BASENAME%"
	addEmulator 0 "$md_id" "radio86" "$md_inst/mess radio86 -cass %BASENAME%"
	addEmulator 0 "$md_id" "m5" "$md_inst/mess m5 -cart %BASENAME%"
	addEmulator 0 "$md_id" "m5" "$md_inst/mess m5 -cass %BASENAME%"
	addEmulator 0 "$md_id" "tutor" "$md_inst/mess tutor -cart %BASENAME%"
	addEmulator 0 "$md_id" "tutor" "$md_inst/mess tutor -cass %BASENAME%"
	addEmulator 0 "$md_id" "pegasus" "$md_inst/mess tutor -cart1 %BASENAME%"
	addEmulator 0 "$md_id" "pegasus" "$md_inst/mess tutor -cass %BASENAME%"
	
	#Many
	
	addEmulator 0 "$md_id" "atom" "$md_inst/mess atom -cart %BASENAME%"
	addEmulator 0 "$md_id" "atom" "$md_inst/mess atom -flop1 %BASENAME%"
	addEmulator 0 "$md_id" "atom" "$md_inst/mess atom -cass %BASENAME%"
	addEmulator 0 "$md_id" "atom" "$md_inst/mess atom -quik %BASENAME%"
	addEmulator 0 "$md_id" "cgenie" "$md_inst/mess cgenie -cart %BASENAME%"
	addEmulator 0 "$md_id" "cgenie" "$md_inst/mess cgenie -flop1 %BASENAME%"
	addEmulator 0 "$md_id" "cgenie" "$md_inst/mess cgenie -cass %BASENAME%"
	addEmulator 0 "$md_id" "adam" "$md_inst/mess adam -cart %BASENAME%"
	addEmulator 0 "$md_id" "adam" "$md_inst/mess adam -flop1 %BASENAME%"
	addEmulator 0 "$md_id" "adam" "$md_inst/mess adam -cass %BASENAME%"
	addEmulator 0 "$md_id" "fmtowns" "$md_inst/mess fmtowns -cdrm %BASENAME%"
	addEmulator 0 "$md_id" "fmtowns" "$md_inst/mess fmtowns -flop1 %BASENAME%"
	addEmulator 0 "$md_id" "fmtowns" "$md_inst/mess fmtowns -hard1 %BASENAME%"
	addEmulator 0 "$md_id" "sorcerer" "$md_inst/mess sorcerer -cart %BASENAME%"
	addEmulator 0 "$md_id" "sorcerer" "$md_inst/mess sorcerer -flop1 %BASENAME%"
	addEmulator 0 "$md_id" "sorcerer" "$md_inst/mess sorcerer -cass1 %BASENAME%"
	addEmulator 0 "$md_id" "sorcerer" "$md_inst/mess sorcerer -quik %BASENAME%"
	addEmulator 0 "$md_id" "sorcerer" "$md_inst/mess sorcerer -dump %BASENAME%"

        addSystem "$system" "$rp_module_desc" ".zip .7z"
}