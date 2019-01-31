# usb-scanner
Custom xboxdrv daemon which allows for improved support and auto-mounting of Xbox and PlayStation controllers

File structure:
```
/
└───lib
    └───usb-scanner
          |   custom_add.list
          |   mounted.list
          └───supported.list

/
└───bin
     └───usb-scanner
```

You can also add a file to `$HOME/.xbodrv` named `layout.conf` with a specific format to specify a specific layout you want your controllers yon follow. For how to format this file, see the `usb-scanner` man page.
