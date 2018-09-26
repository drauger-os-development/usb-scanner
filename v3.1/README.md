##  File usb-scanner-v3.cpp uses `libudev` to get the VID and PID from Xbox Controllers ##
##  As such, if you are working on it, make sure you throw `-ludev`  when you compile and have `libudev-dev` installed otherwise compilation will fail ##

NEW FILE STRUCTURE:
```
/
└───etc
    └───  usb-scanner
          |    check_support_nonstandard.py
          |    check_support_standard.py
          |    supported.sh
          └─── unsupported.sh

/
└─── bin
     └─── usb-scanner
     
```
