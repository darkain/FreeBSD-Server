#!/bin/sh

# INSTALL ALL OF OUR PACKAGES
pkg install -y \
lighttpd \
php83 \
php83-ctype \
php83-curl \
php83-exif \
php83-extensions \
php83-filter \
php83-iconv \
php83-mysqli \
php83-opcache \
php83-pdo_sqlite \
php83-pecl-imagick \
php83-pecl-redis \
php83-phar \
php83-posix \
php83-session \
php83-simplexml \
php83-soap \
php83-sockets \
php83-sodium \
php83-sqlite3 \
php83-tokenizer \
php83-xml \
php83-xmlreader \
php83-xmlwriter \
php83-zip \
php83-zlib


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

# MAKE IT POSSIBLE TO MANUALLY USE THE WWW USER
ln -s /vince/root/.ssh/authorized_keys2 /home/www/.ssh/
chsh -s /bin/sh www
