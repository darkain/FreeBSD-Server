#!/bin/sh

zfs create \
-o mountpoint=/mysql \
-o recordsize=16k \
-o compression=zstd \
-o atime=off \
-o sync=disabled \
-o primarycache=metadata \
-o secondarycache=metadata \
zroot/mysql
