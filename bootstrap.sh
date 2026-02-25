#!/bin/sh -e

# PREP DIRECTORIES
mkdir -p /root/.ssh
mkdir -p /vince
cd /vince


# RECONFIGURE PKG ON FREENAS
if [ `uname -i` = 'FREENAS64' -o `uname -i` = 'TRUENAS' ]; then
	if [ `sysctl -n security.jail.jailed` = 0 ]; then
		sed -i '' 's/: yes/: no/' /usr/local/etc/pkg/repos/local.conf
		sed -i '' 's/: no/: yes/' /usr/local/etc/pkg/repos/FreeBSD.conf
	fi
fi


# RECONFIGURE PKG ON OPNSENSE
if [ `which opnsense-version 2>/dev/null` ]; then
	sed -i '' 's/: no/: yes/' /usr/local/etc/pkg/repos/FreeBSD.conf
fi


# INSTALL GIT ON REDHAT
if [ `which yum 2>/dev/null` ]; then
	yum update -y
	yum install -y git

# INSTALL GIT ON DEBIAN
elif [ `which apt 2>/dev/null` ]; then
	apt-get update
	apt-get upgrade -y
	apt-get install -y git

# INSTALL GIT ON FREEBSD
elif [ `which pkg 2>/dev/null` ]; then

	# USE LATEST REPOSITORY
	if [ `uname -m` = 'amd64' -o `uname -m` = 'arm64' ]; then
		sed -i '' 's/quarterly"/latest"/' /etc/pkg/FreeBSD.conf
	fi

	# BOOTSTRAP PKG IF NOT ALREADY DONE
	if pkg -N 2>/dev/null; then
		cd .
	else
		env ASSUME_ALWAYS_YES=YES pkg bootstrap
	fi

	# REPLACE GIT-LITE WITH GIT-TINY ON FREEBSD
	if `pkg info git-lite >/dev/null 2>&1`; then
		pkg install -y ca_root_nss
	else
		pkg install -y git-tiny ca_root_nss
	fi

	# FORCE HTTPS INSTEAD OF HTTP
	sed -i '' 's/http:/https:/' /etc/pkg/FreeBSD.conf

# ERROR, CANNOT CONTINUE
else
	echo "Unknown package manager" 1>&2
	exit 1
fi


# CLONE LATEST CONFIG
if [ ! -d "/vince/.git" ]; then
	git clone --depth=1 https://github.com/darkain/FreeBSD-Server.git .
else
	git pull
fi


# INSTALL PACKAGES
sh firstrun

# REPLACE DEFAULT FILES
sh symlink.sh


# ENABLE SSH
! rm /etc/ssh/sshd_config 2>/dev/null
ln -s /vince/etc/ssh/sshd_config /etc/ssh/
if [ `uname` = 'Linux' ]; then
	if [ "`systemctl | grep sshd.service`" != '' ]; then
		systemctl enable sshd
		systemctl restart sshd
	elif [ "`systemctl | grep ssh.service`" != '' ]; then
		systemctl enable ssh
		systemctl restart ssh
	fi
elif [ `uname -i` != 'FREENAS64' -a `uname -i` != 'TRUENAS' ]; then
	if [ `which opnsense-version 2>/dev/null` ]; then
		echo 'SSH handled by OPNsense UI'
	else
		sysrc 'sshd_enable=YES'
		service sshd stop
		service sshd start
	fi
elif [ `sysctl -n security.jail.jailed` = 1 ]; then
	sysrc 'sshd_enable=YES'
	service sshd stop
	service sshd start
fi


# ENABLE AUTO-TRIM ON ALL ZPOOLS
if [ `which zpool 2>/dev/null` ]; then
	zpool list -Ho name | while read line; do
		zpool set autotrim=on $line
	done
fi



# SET BOOT DELAY TO 2 SECONDS INSTEAD OF DEFAULT OF 10
if [ `which pkg 2>/dev/null` ]; then
	if ! sysrc -f /boot/loader.conf -q autoboot_delay >/dev/null 2>&1; then
		sysrc -f /boot/loader.conf autoboot_delay="2"
	fi
fi



# DISABLE BELL BEEPING LOLOLOL
if [ `which pkg 2>/dev/null` ]; then
	sysrc allscreens_kbdflags="-b quiet.off"
fi



# RELOAD CSH CONFIG FOR OMG COLOURZ!
chsh -s /bin/csh root
exec tcsh
