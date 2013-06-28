# Papscan

This application allows a scanner and keyboard to be used with a headless computer.  Think of it like an open source photocopier.  Keys are assigned to presets to run actions, such as 't' to do a 200 dpi greyscale scan to upload to a window file share (you may want to print out a list of presets).

* avoid getting a photocopier with expensive per sheet maintenance agreements
* unlimited flexibility in what you do with the scanned page
    + the example script converts to pdf and uploads to a windows file share
* get a high end HP or fujitsu


## Requirements

* bash
* python
* sane / scanadf
* ghostscript (for ps2pdf)
* netpbm (for pnmtops)
* imagemagick (for convert, if using monochrom)

## Similar

* http://icopy.sourceforge.net/ - Similar idea, Windows only, not headless

## Installation

* git clone https://github.com/stan3/papscan.git
* copy config.sh.sample to config.sh and customize
* start the application on a tty from init
    + for traditional init add something like this to /etc/inittab `c7:3:respawn:/sbin/agetty -n -l "/path/to/papscan/initscan.sh" 38400 tty7 linux`
    + with upstart copy /etc/init/tty6.conf to tty7.conf and use `exec /sbin/getty -8 38400 tty7 -n -l /path/to/papscan/initscan.sh`
* (optional) use chvt (part of kbd) to switch to the right virtual console on boot e.g. put `/usr/bin/chvt 7` in rc.local

