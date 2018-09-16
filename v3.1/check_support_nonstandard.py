#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
#  check_support_nonstandard.py
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
import sys
check = sys.argv[1]
print(check)
list_check = ["24c6:530a", "0e6f:011f"]
SENT = 0
for x in list_check:
	if (check == x):
		SENT = 1
		exit(1)
if SENT == 0:
	exit(0)
