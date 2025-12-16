#!/bin/sh


# CREATE BOOT ENVIRONMENT FOR 15.0-RELEASE
bectl create pre-15.0-RELEASE
bectl create 15.0-RELEASE
mkdir /mnt/upgrade
bectl mount 15.0-RELEASE /mnt/upgrade


# CREATE PATH FOR TRUSTED KEY
mkdir -p /mnt/upgrade/usr/share/keys/pkgbase-15/trusted/


# DOWNLOAD TRUSTED KEY FROM FREEBSD SRC MIRROR
fetch -o /mnt/upgrade/usr/share/keys/pkgbase-15/trusted/awskms-15 https://github.com/freebsd/freebsd-src/raw/refs/heads/main/share/keys/pkgbase-15/trusted/awskms-15


# SETUP SOME VARIABLES TO MAKE LIFE A LITTLE EASIER
OLD_PATH='/usr/share/keys/pkg'
NEW_PATH='/usr/share/keys/pkgbase-15'
FILE_PATH="/mnt/upgrade/usr/local/etc/pkg/repos/FreeBSD-base.conf"


# UPDATE REPO
sed -i.bak1 "s#  fingerprints: \"$OLD_PATH\"#  fingerprints: \"$NEW_PATH\"#" "$FILE_PATH"
sed -i.bak2 "s#base_release_3#base_release_0#" "$FILE_PATH"


# UPGRADE FREEBSD!
env ABI=FreeBSD:15:amd64 pkg-static -c /mnt/upgrade upgrade -y -r FreeBSD-base


# SWITCH TO 15.0-RELEASE
bectl activate 15.0-RELEASE

