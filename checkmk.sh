#!/bin/sh

# Install Checkmk Agent and some extra things for it to monitor 
pkg install -y ipmitool libstatgrab check_mk_agent

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
ln -s /usr/local/etc/check_mk /etc/check_mk
ln -s /usr/local/lib/check_mk_agent /var/lib/check_mk_agent

# Fetch my "fixed" check_mk_agent file
fetch -o /usr/local/bin/check_mk_agent https://raw.githubusercontent.com/darkain/checkmk/master/agents/check_mk_agent.freebsd

# Enable and start inetd, thus starting Checkmk agent
sysrc inetd_enable="YES"
service inetd restart
