symlink=".cshrc .nanorc .my.cnf .grcat .login"
delete=".tcshrc"


# FIX SYMLINKS
for item in $symlink; do
	if [ ! -L "/root/$item" ]; then
		echo "Fixing: /root/$item"
		! rm "/root/$item" 2>/dev/null
		ln -s "/vince/root/$item" /root/
	fi
done


# DELETE EXTRA FILES
for item in $delete; do
	if [ -f "/root/$item" ]; then
		echo "Deleting: /root/$item"
		! rm "/root/$item" 2>/dev/null
	fi
done



# RE-ENABLE / FIX SSH
if [ ! -L "/etc/ssh/sshd_config" ]; then
	! rm /etc/ssh/sshd_config 2>/dev/null
	ln -s /vince/etc/ssh/sshd_config /etc/ssh/
	service sshd restart
fi
