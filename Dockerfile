FROM php:8.4-fpm

RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libwebp-dev \
    libfreetype6-dev \
    libjpeg-dev \
    libpq-dev \
    libcurl4-openssl-dev pkg-config libssl-dev libzip-dev \
    unzip \
    zip

RUN docker-php-ext-install bcmath pgsql pdo_pgsql sockets zip xml soap \
    && docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-install pcntl \
    && docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install gd \
    && docker-php-ext-install exif

RUN apt-get install -y libmagickwand-dev libmagickcore-dev imagemagick \
    curl -o /tmp/imagick.tar.gz https://github.com/Imagick/imagick/archive/7088edc353f53c4bc644573a79cdcd67a726ae16.tar.gz \
    && tar --strip-components=1 -xf /tmp/imagick.tar.gz \
    && phpize \
    && ./configure \
    && make \
    && make install\
    && echo "extension=imagick.so" > /usr/local/etc/php/conf.d/ext-imagick.ini \
    && rm -rf /tmp/*
# RUN apt-get install -y libmagickwand-dev libmagickcore-dev imagemagick \
#     && pecl install imagick \
# 	&& docker-php-ext-enable imagick

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