#!/bin/sh

# RANDOMIZE TIME OF DAY - DELAY UP TO 24 HOURS
DELAY=`jot -r 1 0 86400`
echo "Sleeping for ${DELAY} seconds..."
sleep $DELAY




# UPDATE THE "VINCE" SCRIPTS
cd /vince
git pull




# IGNORE KERNEL VS USERLAND VERSION DIFFERENCES
IGNORE_OSVERSION=yes

# UPDATE PACKAGES
pkg update && pkg upgrade -y
