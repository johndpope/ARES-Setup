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

rp_module_id="softreboot"
rp_module_desc="Perform a soft reboot to recover local keyboard function if not functional."
rp_module_section="config"

function gui_softreboot() {
    sudo systemctl restart getty@tty0 && sudo systemctl restart getty@tty1
}
