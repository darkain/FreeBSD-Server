#!/bin/sh


# USE PKGBASIFY
cd /tmp
fetch https://github.com/FreeBSDFoundation/pkgbasify/raw/refs/heads/main/pkgbasify.lua
chmod +x ./pkgbasify.lua
./pkgbasify.lua





# RESTORE IMPORTANT FILES
cp /etc/pkg/FreeBSD.conf.pkgsave /etc/pkg/FreeBSD.conf
cp /etc/group.pkgsave /etc/group
cp /etc/master.passwd.pkgsave /etc/master.passwd
cp /etc/shells.pkgsave /etc/shells
cp /etc/sysctl.conf.pkgsave /etc/sysctl.conf




# JUST SAVE/EXIT, NO NEED TO CHANGE ANYTHING
# THIS IS NEEDED TO UNBREAK THE USER/PASSWORD DATABASE
vipw




# CLEAN UP OLD FILES
find / -name "*.pkgsave" | xargs rm -f




# FIX ROOT SHELL
! rm /root/.cshrc 2>/dev/null
ln -s /vince/root/.cshrc /root/
chsh -s /bin/csh root




# RE-ENABLE / FIX SSH
! rm /etc/ssh/sshd_config 2>/dev/null
ln -s /vince/etc/ssh/sshd_config /etc/ssh/
service sshd restart
