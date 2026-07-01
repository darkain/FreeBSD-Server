#!/bin/sh


# Parse optional CLI parameters
GALERA_MIN=""
for arg in "$@"; do
	case "$arg" in
		--galera=*) GALERA_MIN="${arg#*=}" ;;
	esac
done


# Validate Galera Cluster size (if available)
if [ -n "$GALERA_MIN" ]; then
	GALERA_SIZE=$(mysql -NBe "SHOW STATUS LIKE 'wsrep_cluster_size'" 2>/dev/null | awk '{ print $2 }')
	if [ -z "$GALERA_SIZE" ] || ! echo "$GALERA_SIZE" | grep -q '^[0-9]*$'; then
		echo "Galera query failed or returned invalid response ($GALERA_SIZE), aborting"
		exit 1
	fi
	if [ "$GALERA_SIZE" -lt "$GALERA_MIN" ]; then
		echo "Galera cluster size $GALERA_SIZE < minimum $GALERA_MIN, aborting"
		exit 1
	fi
fi


# Reboot if kerner has been updated
PACKAGE=$(pkg info "FreeBSD-kernel*" | grep -vi FreeBSD-kernel-man | grep -vi dbg | head -1)
if [ -n "$PACKAGE" ]; then
	RUNNING=$(uname -v | awk '{ print $2 }' | sed 's/-RELEASE-//')
	INSTALLED=$(pkg info "$PACKAGE" | grep '^Version' | sed 's/.*: *//')
	if [ "$RUNNING" != "$INSTALLED" ]; then
		echo "Kernel update detected: running=$RUNNING : installed=$INSTALLED"
		/sbin/shutdown -r +1 "Kernel update detected - rebooting"
	fi
fi
