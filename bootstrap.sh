#!/bin/sh -e

# PREP DIRECTORIES
mkdir -p /root/.ssh
mkdir -p /vince
cd /vince

# RECONFIGURE PKG
if [ `uname -i` != 'FREENAS64' ]; then
  if [ `sysctl -n security.jail.jailed` = 0 ]; then
    sed -i '' 's/: yes/: no/' /usr/local/etc/pkg/repos/local.conf
    sed -i '' 's/: no/: yes/' /usr/local/etc/pkg/repos/FreeBSD.conf
  fi
fi

# REMOVE GIT-LITE
if pkg info 'git-lite' | grep 'Version'; then
  pkg remove -y git-lite
fi

# INSTALL GIT AND CLONE LATEST CONFIG
pkg install -y git
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
if [ `uname -i` != 'FREENAS64' ]; then
  sysrc 'sshd_enable=YES'
elif [ `sysctl -n security.jail.jailed` = 1 ]; then
  sysrc 'sshd_enable=YES'
fi
service sshd restart

# RELOAD CSH CONFIG FOR OMG COLOURZ!
csh
