#!/bin/sh

pkg install -y \
lighttpd \
php81 \
php81-ctype \
php81-curl \
php81-exif \
php81-extensions \
php81-filter \
php81-mysqli \
php81-opcache \
php81-pecl-imagick \
php81-pecl-redis \
php81-simplexml \
php81-session \
php81-soap \
php81-sockets \
php81-sodium \
php81-sqlite3 \
php81-tokenizer \
php81-xml \
php81-xmlreader \
php81-xmlwriter \
php81-zip \
php81-zlib

# THESE ARE OPTIONAL, CURRENTLY TURNING THEM OFF
# USAGE OF THESE WILL MOST LIKELY BE REMOVED FROM PUDL
# THEY ARE NOT USED ANYWHERE ELSE IN ALTAFORM OR OTHER DEPENDENCIES
# php74-sysvmsg \
# php74-sysvsem \
# php74-sysvshm \
