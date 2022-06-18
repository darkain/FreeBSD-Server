#!/bin/sh

# INSTALL OPEN-VM-TOOLS
pkg install -y open-vm-tools-nox11

# ENABLE OPEN-VM-TOOLS SERVICE
sysrc vmware_guest_vmmemctl_enable="YES"
sysrc vmware_guest_vmxnet_enable="YES"
sysrc vmware_guest_kmod_enable="YES"
sysrc vmware_guestd_enable="YES"

# START OPEN-VM-TOOLS SERVICE
service vmware-guestd start
