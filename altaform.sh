#!/bin/sh

# INSTALL ALL OF OUR PACKAGES
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


# LISTEN ON ALL INTERFACES, NOT JUST LOCALHOST
sed -i '' 's/listen = 127.0.0.1:9000/listen = 9000/' /usr/local/etc/php-fpm.d/www.conf


# CREATE PATH FOR OUR WEB APP
mkdir /var/www
chown www:www /var/www


# CONFIGURE LIGHTTPD
rm /usr/local/etc/lighttpd/lighttpd.conf
ln -s /vince/usr/local/etc/lighttpd/lighttpd.conf /usr/local/etc/lighttpd/
sysrc lighttpd_enable="YES"
service lighttpd start
