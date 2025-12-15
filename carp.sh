#!/bin/sh

# Taken from:
# https://forum.opnsense.org/index.php?topic=11735.0

sysctl net.inet.carp.senderr_demotion_factor=0
sysctl net.inet.carp.demotion=-$(sysctl -n net.inet.carp.demotion)
