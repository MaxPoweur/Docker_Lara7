FROM php:7.1.3-apache

RUN apt-get -y update --fix-missing
# RUN apt-get upgrade -y

# Install tools & libraries
RUN apt-get -y install apt-utils nano wget dialog \
    build-essential git curl libcurl3 libcurl3-dev zip

# Install important libraries
RUN apt-get -y install --fix-missing apt-utils build-essential git \
    libmcrypt-dev mysql-client zlib1g-dev \
    libicu-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev libmagickwand-dev --no-install-recommends

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# PHP Extensions
RUN pecl install imagick\
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install zip \
    && docker-php-ext-install pcntl \
    && docker-php-ext-install mcrypt \
    && docker-php-ext-install intl \
    && docker-php-ext-install gd \
    && docker-php-ext-install soap \
    && docker-php-ext-enable imagick

# Enable apache modules
RUN a2enmod rewrite headers ssl vhost_alias

COPY ssl/server.crt /etc/apache2/ssl/server.crt
COPY ssl/server.key /etc/apache2/ssl/server.key
COPY docker-init.sh /usr/local/bin/

WORKDIR /var/www/html/src

ENTRYPOINT ["docker-init.sh"]