#!/bin/sh

# INSTALL ALL OF OUR PACKAGES
pkg install -y \
lighttpd \
php84 \
php84-ctype \
php84-curl \
php84-exif \
php84-extensions \
php84-filter \
php84-iconv \
php84-mysqli \
php84-opcache \
php84-pdo_sqlite \
php84-pecl-imagick \
php84-pecl-redis \
php84-phar \
php84-posix \
php84-session \
php84-simplexml \
php84-soap \
php84-sockets \
php84-sodium \
php84-sqlite3 \
php84-tokenizer \
php84-xml \
php84-xmlreader \
php84-xmlwriter \
php84-zip \
php84-zlib


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
