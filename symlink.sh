# FIX ROOT SHELL
! rm /root/.cshrc 2>/dev/null
ln -s /vince/root/.cshrc /root/
chsh -s /bin/csh root




# RE-ENABLE / FIX SSH
! rm /etc/ssh/sshd_config 2>/dev/null
ln -s /vince/etc/ssh/sshd_config /etc/ssh/
service sshd restart
