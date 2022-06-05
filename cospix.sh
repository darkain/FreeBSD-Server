#!/bin/sh -e

cd /var/www

# GET THE INITIAL SOURCE CODE
git clone --branch=live git@github.com:darkain/cospix.net.git .

# FIX GIT'S STUPID BS
git config --global --add safe.directory /var/www

# PULL ALL THE SUBMODULES
git submodule init
git submodule update
