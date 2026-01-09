#!/bin/sh

# For OPNsense, use this instead:
# https://github.com/bashclub/checkmk-opnsense-agent


# Install Checkmk Agent and some extra things for it to monitor
if [ `uname -i` = 'FREENAS64' -o `uname -i` = 'TRUENAS' ]; then
	# Do nothing on FreeNAS/TrueNAS
elif [ `which opnsense-version 2>/dev/null` ]; then
	fetch -o /usr/local/etc/rc.syshook.d/start/99-checkmk_agent https://github.com/bashclub/check-opnsense/raw/main/opnsense_checkmk_agent.py
	chmod +x /usr/local/etc/rc.syshook.d/start/99-checkmk_agent
	pkill -f 99-checkmk_agent
	/usr/local/etc/rc.syshook.d/start/99-checkmk_agent
	exit 0
else
	pkg install -y python ipmitool libstatgrab check_mk_agent
fi


# Register Checkmk TCP Port
LINE='checkmk-agent 6556/tcp #Checkmk monitoring agent'
FILE='/etc/services'
grep -qF -- "$LINE" "$FILE" || echo "$LINE" >> "$FILE"


# Register Checkmk with inetd
LINE='checkmk-agent stream tcp nowait root /usr/local/bin/check_mk_agent check_mk_agent'
FILE='/etc/inetd.conf'
grep -qF -- "$LINE" "$FILE" || echo "$LINE" >> "$FILE"


# Create missing folders
mkdir /usr/local/etc/check_mk
mkdir /usr/local/lib/check_mk_agent
mkdir /usr/local/lib/check_mk_agent/local
mkdir /usr/local/lib/check_mk_agent/plugins
mkdir /usr/local/lib/check_mk_agent/plugins/3600
ln -s /usr/local/etc/check_mk /etc/check_mk
ln -s /usr/local/lib/check_mk_agent /var/lib/check_mk_agent


# Install "pkg audit" plugin
ln -s /vince/usr/local/lib/check_mk_agent/plugins/0-pkg_audit.py /usr/local/lib/check_mk_agent/plugins/3600/


# Fetch latest check_mk_agent file
fetch -o /usr/local/bin/check_mk_agent https://raw.githubusercontent.com/Checkmk/checkmk/master/agents/check_mk_agent.freebsd
chmod +x /usr/local/bin/check_mk_agent


# Enable and start inetd, thus starting Checkmk agent
sysrc inetd_enable="YES"
service inetd restart
