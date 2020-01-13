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
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs openssh-client

# GD Dependencies
RUN apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev libgmp-dev libldb-dev libldap2-dev netcat sqlite3 libsqlite3-dev
RUN ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so \
    && ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/liblber.so
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install gd gmp bcmath pcntl ldap exif

# PHP Extensions
RUN pecl install imagick \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install zip \
    && docker-php-ext-install pcntl \
    && docker-php-ext-install mcrypt \
    && docker-php-ext-install intl \
    && docker-php-ext-install soap \
    && docker-php-ext-enable imagick \
    && docker-php-ext-install bz2

# Enable apache modules
RUN a2enmod rewrite headers ssl vhost_alias

# Certificates used to enable HTTPS
COPY ssl/server.crt /etc/apache2/ssl/server.crt
COPY ssl/server.key /etc/apache2/ssl/server.key

# Add the user "user" with the same UID as the local host user and add it to the sudo group
ARG USER_ID=1000
RUN useradd --shell /bin/bash -u $USER_ID -o -c "" -m user
RUN usermod -aG sudo user
RUN apt install sudo
RUN echo "user     ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers

# Set default user for all next operations
USER user
RUN git config --global http.sslVerify "false"

# Default working directory
WORKDIR /var/www/html/src

# Copy entrypoint script to container bin directory
COPY docker-init.sh /usr/local/bin/

ENTRYPOINT ["docker-init.sh"]