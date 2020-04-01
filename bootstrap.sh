#!/bin/sh -e

# PREP DIRECTORIES
mkdir -p /root/.ssh
mkdir -p /vince
cd /vince


# RECONFIGURE PKG ON FREENAS
if [ `uname -i` = 'FREENAS64' ]; then
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

	# USE LATEST REPOSITORY (X86-64 ONLY, BECAUSE THIS IS BROKEN ON ARM)
	if [ `uname -m` = 'amd64' ]; then
		sed -i '' 's/quarterly"/latest"/' /etc/pkg/FreeBSD.conf
	fi

	# BOOTSTRAP PKG IF NOT ALREADY DONE
	if pkg -N 2>/dev/null; then
		cd .
	else
		env ASSUME_ALWAYS_YES=YES pkg bootstrap
	fi

	# REPLACE GIT-LITE WITH GIT ON FREEBSD
	if `pkg info git-lite >/dev/null 2>&1`; then
		pkg remove -y git-lite
	fi
	pkg install -y git ca_root_nss

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

# REMOVE DEFAULT FILES
! rm /root/.cshrc 2>/dev/null
! rm /root/.tcshrc 2>/dev/null
! rm /root/.nanorc 2>/dev/null
! rm /root/.my.cnf 2>/dev/null
! rm /root/.grcat 2>/dev/null
! rm /root/.login 2>/dev/null
! rm /root/.ssh/authorized_keys 2>/dev/null

# LINK OUR COPY OF THE FILES FROM THE GIT REPO
# WE CAN THEN UPDATE THESE FILES ANY TIME WITH A 'git pull'
ln -s /vince/root/.cshrc /root/
ln -s /vince/root/.nanorc /root/
ln -s /vince/root/.my.cnf /root/
ln -s /vince/root/.grcat /root/
ln -s /vince/root/.login /root/
ln -s /vince/root/.ssh/authorized_keys /root/.ssh/

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
elif [ `uname -i` != 'FREENAS64' ]; then
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

# RELOAD CSH CONFIG FOR OMG COLOURZ!
exec tcsh
