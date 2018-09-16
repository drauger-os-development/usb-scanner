/*
 * usb-scanner-v3.cpp
 *
 * Copyright 2018 Thomas Castleman <draugeros@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 *
 *
 */
#include <iostream>
#include <libudev.h>
#include <stdio.h>
#include <stdlib.h>
#include <locale.h>
#include <unistd.h>
#include <cstdlib>
#include <fstream>
#include <sys/types.h>
#include <pwd.h>
using namespace std;

//for error reporting to the log file at ~/.xboxdrv/LOGFILE.txt
int error(std::string out)
{
	int SENT = 1;
	while ( SENT == 1)
	{
		std::string home = getenv("HOME");
		if (home.empty())
		{
			home = getpwuid(getuid())->pw_dir;
		}
		ofstream errout ((home + "/.xboxdrv/LOGFILE.txt").c_str(), ios::out | ios::app);
		if (errout.is_open())
		{
			errout << out << std::endl;
			SENT = 0;
		}
		else continue;
		errout.close();
	}
	//check file size, if > ~30MB, compress into a zip
	return 0;
}

//check newly mounted USB device for standard support
int check_standard(std::string check)
{
	int success = std::system( ("python3 /etc/usb-scanner/check_support_standard.py " + check).c_str() );
	if (success == 1)
	{
		std::cout << 0;
	}
	else
	{
		std::cout << 1;
	}
	return 0;
}

//check newly mounted USB for non-standard
int check_non_standard(std::string check)
{
	int success = std::system( ("python3 /etc/usb-scanner/check_support_nonstandard.py " + check).c_str() );
	if (success == 1)
	{
		std::cout << 0;
	}
	else
	{
		std::cout << 1;
	}
	return 0;
}

//LISTEN for newly mounted USB devices
string scanner()
{
	struct udev *udev;
	struct udev_device *dev;
	struct udev_monitor *mon;
	int fd;

	//Create the udev object
	udev = udev_new();
	if (!udev)
	{
		error("ERROR: Can't create new udev object");
		return "1";
	}
	//Set up a monitor to monitor input devices
	mon = udev_monitor_new_from_netlink(udev, "udev");
	udev_monitor_filter_add_match_subsystem_devtype(mon, "input", NULL);
	udev_monitor_enable_receiving(mon);
	/* Get the file descriptor (fd) for the monitor.
	   This fd will get passed to select() */
	fd = udev_monitor_get_fd(mon);
	int SENT = 1;
	while (SENT == 1)
	{
		/* Set up the call to select(). In this case, select() will
		   only operate on a single file descriptor, the one
		   associated with our udev_monitor. Note that the timeval
		   object is set to 0, which will cause select() to not
		   block. */
		fd_set fds;
		struct timeval tv;
		int ret;

		FD_ZERO(&fds);
		FD_SET(fd, &fds);
		tv.tv_sec = 0;
		tv.tv_usec = 0;

		ret = select(fd+1, &fds, NULL, NULL, &tv);
		//Check if our file descriptor has received data.
		if (ret > 0 && FD_ISSET(fd, &fds))
		{
			/* Make the call to receive the device.
			select() ensured that this will not block. */
			dev = udev_monitor_receive_device(mon);
			if (dev)
			{
				error("NOTICE: Got Device");
				string action = udev_device_get_action(dev);
				string v = udev_device_get_sysattr_value(dev,"idVendor");
				string p = udev_device_get_sysattr_value(dev,"idProduct");
				string vpid = "24c6:530a";//v + ":" + p;
				if (action == "add")
				{
					SENT = 0;
				}
				udev_device_unref(dev);
				udev_unref(udev);
				return vpid;
			}
			else
			{
				error("ERROR: No Device from receive_device().");
			}
		}
		usleep(100000);
		fflush(stdout);
	}
	return "0";
}

//main function
int main ()
{
	int SENT = 1;
	while (SENT == 1)
	{
		string new_usb;
		new_usb = scanner();
		cout << new_usb;
		int stand_sup = check_standard(new_usb);
		if (stand_sup == 1)
		{
			int non_stand_sup = check_non_standard(new_usb);
			if (non_stand_sup == 0)
			{
				int pid = fork();
				if (pid == 0)
				{
					execl("bash", "/etc/usb-scanner/unsupported.sh", new_usb, (char *) 0);
				}
			}
		}
		else if (stand_sup == 0)
		{
			int pid = fork();
			if (pid == 0)
			{
				execl("bash", "/etc/usb-scanner/supported.sh", (char *) 0);
			}
		}
	}
}

