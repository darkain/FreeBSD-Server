# FIX ROOT SHELL
if [ ! -L "/root/.cshrc" ]; then
	! rm /root/.cshrc 2>/dev/null
	ln -s /vince/root/.cshrc /root/
	chsh -s /bin/csh root
fi



# RE-ENABLE / FIX SSH
if [ ! -L "/etc/ssh/sshd_config" ]; then
	! rm /etc/ssh/sshd_config 2>/dev/null
	ln -s /vince/etc/ssh/sshd_config /etc/ssh/
	service sshd restart
fi
