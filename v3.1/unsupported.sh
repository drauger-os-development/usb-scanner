#!/bin/bash
# -*- coding: utf-8 -*-
#
#  unsupported.sh
#  
#  Copyright 2018 Thomas Castleman <draugeros@gmail.com>
#  
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#  
# 

def xbdrv (y) {
    xboxdrv --detach-kernel-driver -s --device-name "Game Pad" --device-by-id "$y" --type xbox360 --deadzone 4000 --dpad-as-button --trigger-as-button --ui-axismap "x2=REL_X:20,y2=REL_Y:20,x1=KEY_A:KEY_D,y1=KEY_W:KEY_S" --ui-buttonmap "tl=KEY_LEFTSHIFT,tr=KEY_LEFTCTRL" --ui-buttonmap "a=KEY_SPACE,b=KEY_C,x=KEY_1,y=KEY_R" --ui-buttonmap "lb=KEY_Q,rb=KEY_E" --ui-buttonmap "lt=BTN_RIGHT,rt=BTN_LEFT" --ui-buttonmap "dl=KEY_4,dr=KEY_B,du=BTN_MIDDLE,dd=KEY_TAB" --ui-buttonmap "back=KEY_ESC,start=KEY_ENTER" &
}
gksudo xbdrv("$1")
