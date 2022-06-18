#!/bin/sh

zfs create \
mountpoint=/mysql \
recordsize=16k \
compression=zstd \
atime=off \
sync=disabled \
primarycache=metadata \
secondarycache=metadata \
zroot/mysql
