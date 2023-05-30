FROM php:8.1-apache

# use development config
# https://hub.docker.com/_/php
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# install composer
# https://stackoverflow.com/a/58694421/1593188
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# install git
RUN apt-get -y update

# install git
RUN apt-get -y install git

# install zip
RUN apt-get -y install zip

# install mysql driver
RUN docker-php-ext-install pdo_mysql

# install Int bundle
RUN apt-get install -y libicu-dev
RUN docker-php-ext-configure intl && docker-php-ext-install intl

# install npm
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - &&\
apt-get install -y nodejs
RUN npm install --global yarn

# install xdebug
# https://hub.docker.com/_/php
RUN pecl install xdebug && docker-php-ext-enable xdebug
COPY docker/php/xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# enable apache rewrite module
RUN a2enmod rewrite

# set the document root in apache config
# https://stackoverflow.com/a/51457728/1593188
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
