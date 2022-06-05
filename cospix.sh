#!/bin/sh -e

# MAKE SURE ALL PACKAGES ARE INSTALLED FIRST
sh altaform.sh

# MOVE TO OUR WORKING DIRECTORY
cd /var/www

# GET THE INITIAL SOURCE CODE
git clone --branch=live git@github.com:darkain/cospix.net.git .

# FIX GIT'S STUPID BS
git config --global --add safe.directory /var/www

# PULL ALL THE SUBMODULES
git submodule init
git submodule update

# SET OWNER TO WWW USER
chown -R www:www /var/www
