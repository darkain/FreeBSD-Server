#!/bin/sh

# PREP DIRECTORIES
mkdir /root/.ssh
mkdir /vince
cd /vince

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
echo 'sshd_enable="YES"' > /etc/rc.conf.local
service sshd start

# RELOAD CSH CONFIG FOR OMG COLOURZ!
csh
