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

# Enable and start inetd, thus starting Checkmk agent
sysrc inetd_enable="YES"
service inetd restart
