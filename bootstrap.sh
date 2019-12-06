#!/bin/sh -e

# PREP DIRECTORIES
mkdir -p /root/.ssh
mkdir -p /vince
cd /vince

# RECONFIGURE PKG
if [ `uname -i` = 'FREENAS64' ]; then
	if [ `sysctl -n security.jail.jailed` = 0 ]; then
		sed -i '' 's/: yes/: no/' /usr/local/etc/pkg/repos/local.conf
		sed -i '' 's/: no/: yes/' /usr/local/etc/pkg/repos/FreeBSD.conf
	fi
fi

# FREEBSD SPECIFIC CONFIGURATION
if [ "$(uname)" = 'FreeBSD' ]; then

	# BOOTSTRAP PKG IF NOT ALREADY DONE
	if pkg -N 2>/dev/null; then
	else
		env ASSUME_ALWAYS_YES=YES pkg bootstrap
	fi

	# REPLACE GIT-LITE WITH GIT ON FREEBSD
	if pkg info 'git-lite' | grep 'Version'; then
		pkg remove -y git-lite
		pkg install -y git
	fi
fi

# INSTALL GIT ON DEBIAN
if [ `uname` = 'Linux' ]; then
	apt-get update
	apt-get upgrade -y
	apt-get install -y git
fi

# CLONE LATEST CONFIG
git clone --depth=1 https://github.com/darkain/FreeBSD-Server.git .

# INSTALL PACKAGES
sh firstrun

# REMOVE DEFAULT FILES
rm /root/.cshrc
rm /root/.nanorc
rm /root/.my.cnf
rm /root/.login
rm /root/.ssh/authorized_keys

# LINK OUR COPY OF THE FILES FROM THE GIT REPO
# WE CAN THEN UPDATE THESE FILES ANY TIME WITH A 'git pull'
ln -s /vince/root/.cshrc /root/
ln -s /vince/root/.nanorc /root/
ln -s /vince/root/.my.cnf /root/
ln -s /vince/root/.login /root/
ln -s /vince/root/.ssh/authorized_keys /root/.ssh/

# ENABLE SSH
rm /etc/ssh/sshd_config
ln -s /vince/etc/ssh/sshd_config /etc/ssh/
if [ `uname` = 'Linux' ]; then
	service ssh start
elif [ `uname -i` != 'FREENAS64' ]; then
	sysrc 'sshd_enable=YES'
	service sshd restart
elif [ `sysctl -n security.jail.jailed` = 1 ]; then
	sysrc 'sshd_enable=YES'
	service sshd restart
fi

# MOVE TO HOME DIRECTORY
cd ~

# RELOAD CSH CONFIG FOR OMG COLOURZ!
csh
