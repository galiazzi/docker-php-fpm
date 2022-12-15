FROM php:7.4-fpm

RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libcurl4-openssl-dev pkg-config libssl-dev \
    libzip-dev zip unzip \
    libpq-dev

RUN docker-php-ext-install \
    bcmath pgsql pdo_pgsql \
    sockets gd zip xml

RUN pecl install redis && docker-php-ext-enable redis

RUN pecl install mongodb \
    &&  echo "extension=mongodb.so" > $PHP_INI_DIR/conf.d/mongo.ini

RUN docker-php-ext-install opcache
COPY opcache.ini $PHP_INI_DIR/conf.d/opcache.ini