#!/bin/sh

# RANDOMIZE DELAY - UP TO 1 HOUR
DELAY=`jot -r 1 0 3600`
echo "Sleeping for ${DELAY} seconds..."
sleep $DELAY




# UPDATE THE "VINCE" SCRIPTS
cd /vince
git pull




# IGNORE KERNEL VS USERLAND VERSION DIFFERENCES
IGNORE_OSVERSION=yes

# UPDATE PACKAGES
pkg update && pkg upgrade -y
