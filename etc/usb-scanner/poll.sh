#!/bin/bash
# -*- coding: utf-8 -*-
#
#  poll.sh
#  
#  Copyright 2019 Thomas Castleman <contact@draugeros.org>
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
set -e
set -o pipefail
if $(/bin/ls /sys/class/input | /bin/grep -q '^js'); then
	list=$(/bin/ls /sys/class/input | /bin/grep '^js')
	list=$(/bin/echo "$list" | /usr/bin/tr '\n' ' ')
else
	list=""
fi
if [[ -z "$list" ]] || [ "$list" == "" ] || [ "$list" == " " ]; then
	/bin/echo ""
	exit 1
else
	for each in $list; do
		{
			VID=$(/bin/cat "/sys/class/input/$each/device/id/vendor") 
		} || {
			/etc/usb-scanner/log-out "2" "/etc/usb-scanner/poll.sh" "Cannot cat Vendor ID file" "usb-scanner" "$PWD" "$0"
			/bin/echo ""
			exit 2
		}
		{
			PID=$(/bin/cat "/sys/class/input/$each/device/id/product")
		} || {
			/etc/usb-scanner/log-out "2" "/etc/usb-scanner/poll.sh" "Cannot cat Product ID file" "usb-scanner" "$PWD" "$0"
			/bin/echo ""
			exit 2
		}
		if [ -z "$list_out" ]; then
			list_out="$VID:$PID"
		else
			list_out="$list_out $VID:$PID"
		fi
	done
	/bin/echo "$list_out"
fi



