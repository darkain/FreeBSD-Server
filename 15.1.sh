#!/bin/sh

# ENSURE WE HAVE A SANE PKGBASE CONFIG
echo "FreeBSD-base: { enabled: yes }" > /usr/local/etc/pkg/repos/FreeBSD-base.conf

# NEW BOOT ENV
bectl list | grep -q "pre-15.1" || bectl create -r pre-15.1

# UPGRADE PKGBASE
pkg -oABI=FreeBSD:15:$(uname -p) -oOSVERSION=1501000 upgrade -r FreeBSD-base

# KMODS TOO, JUST IN CASE
pkg upgrade -r FreeBSD-ports-kmods
