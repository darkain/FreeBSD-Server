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


# SETUP PHP.INI
cp /usr/local/etc/php.ini-production /usr/local/etc/php.ini
sed -i '' 's/post_max_size = 8M/post_max_size = 50M/' /usr/local/etc/php.ini
sed -i '' 's/upload_max_filesize = 2M/upload_max_filesize = 50M/' /usr/local/etc/php.ini


# LISTEN ON ALL INTERFACES, NOT JUST LOCALHOST, AND START PHP-FPM INSTANCE
sed -i '' 's/listen = 127.0.0.1:9000/listen = 0.0.0.0:9000/' /usr/local/etc/php-fpm.d/www.conf
sysrc php_fpm_enable="YES"
service php-fpm start


# CREATE PATH FOR OUR WEB APP
mkdir /var/www
chown www:www /var/www


# CONFIGURE LIGHTTPD
rm /usr/local/etc/lighttpd/lighttpd.conf
ln -s /vince/usr/local/etc/lighttpd/lighttpd.conf /usr/local/etc/lighttpd/
sysrc lighttpd_enable="YES"
service lighttpd start


# CREATE FOLDER TO HOLD SSH KEY PAIR
mkdir /home
mkdir /home/www
mkdir /home/www/.ssh

# CREATE SSH KEY PAIR FOR WEB APP
echo 'Please enter email address for new SSH key (eg: git/github/gitlab account)'
read email
ssh-keygen -t ed25519 -C $email -N '' -f /home/www/.ssh/id_ed25519

# CHANGE OWNER OF NEW DIRECTORY, AND SET IT AS HOME DIERCTORY
chown -R www:www /home/www
pw usermod -n www -d /home/www
