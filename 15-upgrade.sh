#!/bin/sh


# CREATE PATH FOR TRUSTED KEY
mkdir -p /usr/share/keys/pkgbase-15/trusted/

# DOWNLOAD TRUSTED KEY FROM FREEBSD SRC MIRROR
fetch -o /usr/share/keys/pkgbase-15/trusted/awskms-15 https://github.com/freebsd/freebsd-src/raw/refs/heads/main/share/keys/pkgbase-15/trusted/awskms-15


# SETUP SOME VARIABLES TO MAKE LIFE A LITTLE EASIER
OLD_PATH='/usr/share/keys/pkg'
NEW_PATH='/usr/share/keys/pkgbase-15'
FILE_PATH="/usr/local/etc/pkg/repos/FreeBSD-base.conf"

# UPDATE REPO
sed -i.bak1 "s#  fingerprints: \"$OLD_PATH\"#  fingerprints: \"$NEW_PATH\"#" "$FILE_PATH"
sed -i.bak2 "s#base_release_3#base_release_0#" "$FILE_PATH"


# UPGRADE FREEBSD!
env ABI=FreeBSD:15:amd64 pkg-static upgrade -y -r FreeBSD-base
