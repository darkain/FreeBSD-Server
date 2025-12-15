zpool list -Ho name | while read line; do
	echo "@daily	root	/sbin/zpool scrub $line" > /etc/cron.d/scrub_$line
done
