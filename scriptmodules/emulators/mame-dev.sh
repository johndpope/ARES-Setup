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

rp_module_id="mame"
rp_module_desc="MAME emulator"
rp_module_help="ROM Extensions: .zip .7z\n\nCopy your MAME roms to either $romdir/mame or\n$romdir/arcade"
rp_module_licence="GPL2 https://github.com/mamedev/mame/blob/master/LICENSE.md"
rp_module_section="sa"
rp_module_flags="!armv6"

function _latest_ver_mame() {
    wget -qO- https://api.github.com/repos/mamedev/mame/releases/latest | grep -m 1 tag_name | cut -d\" -f4
}

function _get_binary_name_mame() {
    # The MAME executable on 64-bit systems is called mame64 instead of mame. Rename it back to mame.
    if isPlatform "64bit"; then
        echo 'mamearcade64'
    else
        echo 'mamearcade'
    fi
}

function depends_mame() {
    if compareVersions $__gcc_version lt 6.0.0; then
        md_ret_errors+=("Sorry, you need an OS with gcc 6.0 or newer to compile mame")
        return 1
    fi

    # Additional libraries required for running
    getDepends libsdl2-ttf-2.0-0

    # Additional libraries required for compilation
    getDepends libfontconfig1-dev qt5-default libsdl2-ttf-dev libxinerama-dev
}

function sources_mame() {
    gitPullOrClone "$md_build" https://github.com/mamedev/mame.git "$(_latest_ver_mame)"
}

function build_mame() {
    # More memory is required for x86 platforms
    if isPlatform "x86"; then
        rpSwap on 8192
    else
        rpSwap on 5120
    fi

    # Compile MAME
    make SUBTARGET=arcade ARCHOPTS=-U_FORTIFY_SOURCE NOWERROR=1 -j1

    if isPlatform "64bit"; then
        strip mamearcade64
    else
        strip mamearcade
    fi

    rpSwap off
    md_ret_require="$md_build/$(_get_binary_name_${md_id})"
}

function install_mame() {
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

function configure_mame() {
    local system="mame"
    mkRomDir "arcade"
    mkRomDir "$system"

    moveConfigDir "$home/.mame" "$md_conf_root/$system"

    # Create required MAME directories underneath the ROM directory
    if [[ "$md_mode" == "install" ]]; then
        local mame_sub_dir
        for mame_sub_dir in artwork cfg comments diff inp nvram samples scores snap sta; do
            mkRomDir "$system/$mame_sub_dir"
        done
    fi

    # Create a BIOS directory, where people will be able to store their BIOS files, separate from ROMs
    mkUserDir "$biosdir/$system"
    chown $user:$user "$biosdir/$system"

    # Create a new INI file if one does not already exist
    if [[ "$md_mode" == "install" && ! -f "$md_conf_root/$system/mame.ini" ]]; then
        pushd "$md_conf_root/$system/"
        "$md_inst/$(_get_binary_name_${md_id})" -createconfig
        popd

        iniConfig " " "" "$md_conf_root/$system/mame.ini"
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
        chmod a+r "$md_conf_root/$system/mame.ini"
    fi

    local binary_name="$(_get_binary_name_${md_id})"
    addEmulator 0 "$md_id" "arcade" "$md_inst/${binary_name} %BASENAME%"
    addEmulator 1 "$md_id" "$system" "$md_inst/${binary_name} %BASENAME%"

    addSystem "arcade" "$rp_module_desc" ".zip .7z"
    addSystem "$system" "$rp_module_desc" ".zip .7z"
}