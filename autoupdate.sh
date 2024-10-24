#!/bin/sh


# INSTALL CRON JOB
if [ "$1" = "install" ]; then
	echo "INSTALLING!"
	echo "@daily	root	/bin/sh /vince/autoupdate.sh delay" > /etc/cron.d/autoupdate
	exit 0;
fi




# RANDOMIZE TIME OF DAY - DELAY UP TO 24 HOURS
if [ "$1" = "delay" ]; then
	DELAY=`jot -r 1 0 86400`
	echo "Sleeping for ${DELAY} seconds..."
	sleep $DELAY
fi




# UPDATE THE "VINCE" SCRIPTS
cd /vince
git pull




# IGNORE KERNEL VS USERLAND VERSION DIFFERENCES
IGNORE_OSVERSION=yes

# UPDATE PACKAGES
pkg update && pkg upgrade -y
