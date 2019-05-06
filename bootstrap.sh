#!/bin/sh

mkdir /root/.ssh
mkdir /vince
cd /vince

pkg install -y git
git clone --depth=1 https://github.com/darkain/FreeBSD-Server.git .

sh firstrun

rm /root/.cshrc
rm /root/.nanorc
rm /root/.my.cnf
rm /root/.login
rm /root/.ssh/authorized_keys

ln -s /vince/root/.cshrc /root/
ln -s /vince/root/.nanorc /root/
ln -s /vince/root/.my.cnf /root/
ln -s /vince/root/.login /root/
ln -s /vince/root/.ssh/authorized_keys /root/.ssh/

csh
