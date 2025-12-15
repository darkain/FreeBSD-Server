#!/bin/sh

if test -d "/boot/efi/efi"; then
	cp /boot/loader.efi /boot/efi/efi/freebsd/loader.efi
	cp /boot/loader.efi /boot/efi/efi/boot/bootx64.efi
	echo 'efi partition updated'

	exit 0
fi

echo 'ERROR: efi partition not mounted'
exit 1
