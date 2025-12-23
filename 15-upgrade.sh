#!/bin/sh

# QUICK-EXIT ON ERROR
set -e


# GET THE CURRENT ARCHITECTURE
ARCH=$(uname -p)


# CREATE BOOT ENVIRONMENT FOR 15.0-RELEASE
echo 'Creating boot environment'
bectl create pre-15.0-RELEASE
bectl create 15.0-RELEASE
mkdir /mnt/upgrade
bectl mount 15.0-RELEASE /mnt/upgrade


# CREATE PATH FOR TRUSTED KEY
echo 'Creating path for trusted key'
mkdir -p /mnt/upgrade/usr/share/keys/pkgbase-15/trusted/


# DOWNLOAD TRUSTED KEY FROM FREEBSD SRC MIRROR
echo 'Downloading trusted key'
fetch -o /mnt/upgrade/usr/share/keys/pkgbase-15/trusted/awskms-15 \
  https://github.com/freebsd/freebsd-src/raw/refs/heads/main/share/keys/pkgbase-15/trusted/awskms-15


# SETUP SOME VARIABLES TO MAKE LIFE A LITTLE EASIER
OLD_PATH='/usr/share/keys/pkg'
NEW_PATH='/usr/share/keys/pkgbase-15'
FILE_PATH="/mnt/upgrade/usr/local/etc/pkg/repos/FreeBSD-base.conf"


# UPDATE REPO
echo 'Updating pkgbase url'
sed -i.bak1 "s#  fingerprints: \"$OLD_PATH\"#  fingerprints: \"$NEW_PATH\"#" "$FILE_PATH"
sed -i.bak2 "s#base_release_3#base_release_0#" "$FILE_PATH"


# UPGRADE FREEBSD!
echo 'Running upgrade...'
env PERMISSIVE=yes ABI=FreeBSD:15:$ARCH pkg-static -c /mnt/upgrade install misc/compat14x
env PERMISSIVE=yes ABI=FreeBSD:15:$ARCH pkg-static -c /mnt/upgrade upgrade -y -r FreeBSD-base


# SWITCH TO 15.0-RELEASE
echo 'Switching to 15.0-RELEASE'
bectl activate 15.0-RELEASE

