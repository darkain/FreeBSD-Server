#!/bin/sh


# ENABLE LINUX SUPPORT
sysrc linux_enable="YES"
service linux start


# INSTALL THE DESKTOP
pkg install -y kde plasma6-sddm-kcm sddm xorg firefox linux-sublime-text4

#WE NEED DBUS
service dbus enable && service dbus start

#START THE GRAPHICAL LOGIN SERVICE
service sddm enable && service sddm start
