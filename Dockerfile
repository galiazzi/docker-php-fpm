FROM php:8.0-fpm

RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libwebp-dev \
    libfreetype6-dev \
    libjpeg-dev \
    zip \
    libpq-dev libcurl4-gnutls-dev \
    unzip

RUN apt-get install -y libcurl4-openssl-dev pkg-config libssl-dev

RUN docker-php-ext-install \
    bcmath pgsql pdo_pgsql sockets

RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install gd

RUN apt-get install -y libmagickwand-dev libmagickcore-dev imagemagick \
    && pecl install imagick \
	&& docker-php-ext-enable imagick

RUN pecl install redis && docker-php-ext-enable redis

RUN pecl install mongodb \
    &&  echo "extension=mongodb.so" > $PHP_INI_DIR/conf.d/mongo.ini

RUN docker-php-ext-install opcache
COPY opcache.ini $PHP_INI_DIR/conf.d/opcache.ini

RUN apt-get install -y libgmp-dev \
    && docker-php-ext-install gmp

RUN pecl install apcu \
    && docker-php-ext-enable apcu \
    && pecl clear-cache

RUN docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && docker-php-ext-enable intl

