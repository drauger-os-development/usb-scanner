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
while true; do
	if $( ls /sys/class/input | grep -q '^js'); then
		list=$(ls /sys/class/input | grep '^js')
		list=$(echo "$list" | tr '\n' ' ')
	else
		list=""
	fi
	if [[ ! -z "$check" ]] && [ "$check" != "" ] && [ "$check" != " " ]; then
		list_backup="$list"
		for each in $check; do
			list=$(echo "$list" | tr "$each")
		done
	fi
	if [[ ! -z "$list" ]] && [ "$list" != "" ] && [ "$list" != " " ]; then
		for each in $list; do
			/etc/usb-scanner/detect "$each"
			:
		done
	fi
	echo "$list"
	check="$list_backup"
	sleep 0.15s
done
