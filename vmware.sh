#!/bin/sh


# REMOVE EXISTING INSTALL BEOFRE ATTEMPTING INSTALL
if [ "$1" = "reinstall" ]; then
	echo "UNINSTALLING OPEN VM TOOLS!"
  pkg rmeove -f open-vm-tools-nox11 open-vm-kmod
fi


# INSTALL OPEN-VM-TOOLS
echo "INSTALLING OPEN VM TOOLS!"
pkg install -y open-vm-tools-nox11 open-vm-kmod

# ENABLE OPEN-VM-TOOLS SERVICES
sysrc vmware_guest_vmmemctl_enable="YES"
sysrc vmware_guest_vmxnet_enable="YES"
sysrc vmware_guest_kmod_enable="YES"
sysrc vmware_guestd_enable="YES"

# START OPEN-VM-TOOLS SERVICES
echo "STARTING OPEN VM TOOLS!"
service vmware-guestd restart
service vmware-kmod restart
