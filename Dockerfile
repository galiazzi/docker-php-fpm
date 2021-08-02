FROM php:8-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    libpq-dev libcurl4-gnutls-dev \
    unzip

RUN apt-get install -y libcurl4-openssl-dev pkg-config libssl-dev

RUN pecl install mongodb \
    &&  echo "extension=mongodb.so" > $PHP_INI_DIR/conf.d/mongo.ini

RUN docker-php-ext-install \
    bcmath pgsql pdo_pgsql curl \
    sockets gd

RUN pecl install redis && docker-php-ext-enable redis

RUN docker-php-ext-install opcache
COPY opcache.ini $PHP_INI_DIR/conf.d/opcache.ini