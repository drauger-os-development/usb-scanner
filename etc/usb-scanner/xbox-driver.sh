#!/bin/bash
# -*- coding: utf-8 -*-
#
#  xbox-driver.sh
#  
#  Copyright 2019 Thomas Castleman <contact@draugeros.ml>
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
cache="/lib/usb-scanner"
usb_loc="$cache/usb.list"
mounted_loc="$cache/mounted.list"
mounted=$(/bin/cat $mounted_loc)
custom_add=$(/bin/cat "$cache/custom_add.list")
supported=$(/bin/cat "$cache/supported.list")
edit="$cache/edit.list"
fm="0"
cm="0"
while getopts 'fc' flag; do
	case "${flag}" in
		c) cm="1" ;;
		f) fm="1" ;;
		*) fm="0"; cm="0" ;;
	esac
done
if [ "$cm" == "0" ]; then
	mapping=$(/bin/cat /lib/usb-scanner/standard_layout.conf || ( /bin/echo '/lib/usb-scanner/standard_layout.conf cannot be read' && exit 2 ))
elif [ "$cm" == "1" ]; then
	mapping=$(/etc/usb-scanner/import /etc/usb-scanner/usb-scanner.lib parser)
	contents=$(/bin/cat $HOME/.xboxdrv/layout.conf)
else
	echo "Error reading flags."
	exit 2
fi
eval "$mapping"
if [ "$fm" == "0" ]; then
	inf=1
	while [ "$inf" == "1" ]; do
	#scan usb devices and get list of Product:Vendor IDs (PVIDs)
		/bin/sleep 0.1s
		#gain VID/PID
		usb=$(lsusb | /bin/sed -e 's/.*ID \([a-f0-9]\+:[a-f0-9]\+\).*/\1/g')
		/bin/rm $usb_loc
		#current USB state
		/bin/echo "$usb" >> $usb_loc
		#check to see if any of them are already mounted
		for y in $usb; do
			/bin/sleep 0.1s
			/bin/echo $mounted | /bin/grep  -q -e "$y" && /bin/sed -i "/\b\($y\)\b/d" $usb_loc && usb=$(/bin/cat $usb_loc)
		done
		{
			#check for typical support from xboxdrv and mount the countroller in that manner if it is supported
			for y in $usb; do
				/bin/sleep 0.1s
				/bin/echo $supported | /bin/grep  -q -e "$y" && (/usr/bin/pkexec /usr/bin/xboxdrv --detach-kernel-driver &) && /bin/echo "$y" >> $mounted_loc && mounted=$(/bin/cat $mounted_loc)
			done
		} || {
			#if the above method fails, attempt the custom method (mapping the controller keys to keyboard keys so it basicly emulates a keyboard)
			for y in $usb; do
				/bin/sleep 0.1s
				/bin/echo "$custom_add" | /bin/grep  -q -e "$y" && (/usr/bin/pkexec /usr/bin/xboxdrv --detach-kernel-driver -s --device-name "Game Pad" --device-by-id "$y" --type xbox360 --deadzone 4000 --dpad-as-button --trigger-as-button --ui-axismap "x2=$RIGHTANALOG_X,y2=$RIGHTANALOG_Y,x1=$LEFTANALOG_X,y1=$LEFTANALOG_Y" --ui-buttonmap "tl=$LEFT_BUT,tr=$RIGHT_BUT" --ui-buttonmap "a=$A_BUT,b=$B_BUT,x=$X_BUT,y=$Y_BUT" --ui-buttonmap "lb=$LEFT_BUMP,rb=$RIGHT_BUMP" --ui-buttonmap "lt=$LEFT_TRIG,rt=$RIGHT_TRIG" --ui-buttonmap "dl=$LEFT,dr=$RIGHT,du=$UP,dd=$DOWN" --ui-buttonmap "back=$BACK_BUT,start=$START_BUT,guide=$HOME_BUT" &) && /bin/echo "$y" >> $mounted_loc && mounted=$(/bin/cat $mounted_loc)
			done
		} || {
			#clear it's sort of cache on the internal drive
			/bin/rm $mounted_loc
			/bin/echo "0000:0000" >> $mounted_loc
		}
		#modify the running log of what is mounted
		/bin/echo "$mounted" >> "$edit"
		for f in $mounted; do
			/bin/sleep 0.1s
			(/bin/echo "$usb" | /bin/grep  -q -e "$f") || /bin/sed -i "/\b\($f\)\b/d" $edit
		done
		#update the log in memory
		mounted=$(/bin/cat $edit)
		#clear out needless olf files
		/bin/rm "$edit"
	done
elif [ "$fm" == "1" ]; then
	inf=1
	while [ "$inf" == "1" ]; do
	#scan usb devices and get list of Product:Vendor IDs (PVIDs)
		/bin/sleep 0.1s
		#gain VID/PID
		usb=$(lsusb | /bin/sed -e 's/.*ID \([a-f0-9]\+:[a-f0-9]\+\).*/\1/g')
		/bin/rm $usb_loc
		#current USB state
		/bin/echo "$usb" >> $usb_loc
		#check to see if any of them are already mounted
		for y in $usb; do
			/bin/sleep 0.1s
			/bin/echo $mounted | /bin/grep  -q -e "$y" && /bin/sed -i "/\b\($y\)\b/d" $usb_loc && usb=$(/bin/cat $usb_loc)
		done
		{
			#check for typical support from xboxdrv and mount the countroller in that manner if it is supported
			for y in $usb; do
				/bin/sleep 0.1s
				/bin/echo $supported | /bin/grep  -q -e "$y" && (/usr/bin/pkexec /usr/bin/xboxdrv --detach-kernel-driver -s --device-name "Game Pad" --device-by-id "$y" --type xbox360 --deadzone 4000 --dpad-as-button --trigger-as-button --ui-axismap "x2=$RIGHTANALOG_X,y2=$RIGHTANALOG_Y,x1=$LEFTANALOG_X,y1=$LEFTANALOG_Y" --ui-buttonmap "tl=$LEFT_BUT,tr=$RIGHT_BUT" --ui-buttonmap "a=$A_BUT,b=$B_BUT,x=$X_BUT,y=$Y_BUT" --ui-buttonmap "lb=$LEFT_BUMP,rb=$RIGHT_BUMP" --ui-buttonmap "lt=$LEFT_TRIG,rt=$RIGHT_TRIG" --ui-buttonmap "dl=$LEFT,dr=$RIGHT,du=$UP,dd=$DOWN" --ui-buttonmap "back=$BACK_BUT,start=$START_BUT,guide=$HOME_BUT" &) && /bin/echo "$y" >> $mounted_loc && mounted=$(/bin/cat $mounted_loc)
			done
		} || {
			#if the above method fails, attempt the custom method (mapping the controller keys to keyboard keys so it basicly emulates a keyboard)
			for y in $usb; do
				/bin/sleep 0.1s
				/bin/echo "$custom_add" | /bin/grep  -q -e "$y" && (/usr/bin/pkexec /usr/bin/xboxdrv --detach-kernel-driver -s --device-name "Game Pad" --device-by-id "$y" --type xbox360 --deadzone 4000 --dpad-as-button --trigger-as-button --ui-axismap "x2=$RIGHTANALOG_X,y2=$RIGHTANALOG_Y,x1=$LEFTANALOG_X,y1=$LEFTANALOG_Y" --ui-buttonmap "tl=$LEFT_BUT,tr=$RIGHT_BUT" --ui-buttonmap "a=$A_BUT,b=$B_BUT,x=$X_BUT,y=$Y_BUT" --ui-buttonmap "lb=$LEFT_BUMP,rb=$RIGHT_BUMP" --ui-buttonmap "lt=$LEFT_TRIG,rt=$RIGHT_TRIG" --ui-buttonmap "dl=$LEFT,dr=$RIGHT,du=$UP,dd=$DOWN" --ui-buttonmap "back=$BACK_BUT,start=$START_BUT,guide=$HOME_BUT" &) && /bin/echo "$y" >> $mounted_loc && mounted=$(/bin/cat $mounted_loc)
			done
		} || {
			#clear it's sort of cache on the internal drive
			/bin/rm $mounted_loc
			/bin/echo "0000:0000" >> $mounted_loc
		}
		#modify the running log of what is mounted
		/bin/echo "$mounted" >> "$edit"
		for f in $mounted; do
			/bin/sleep 0.1s
			(/bin/echo "$usb" | /bin/grep  -q -e "$f") || /bin/sed -i "/\b\($f\)\b/d" $edit
		done
		#update the log in memory
		mounted=$(/bin/cat $edit)
		#clear out needless olf files
		/bin/rm "$edit"
	done
fi