#!/bin/sh

# NEW BOOT ENV
bectl create -r pre-15.1

# UPGRADE PKGBASE
pkg -oABI=FreeBSD:15:$(uname -p) -oOSVERSION=1501000 upgrade -r FreeBSD-base

# KMODS TOO, JUST IN CASE
pkg upgrade -r FreeBSD-ports-kmods
