FROM php:7.4.8-fpm

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y \
    curl \
    g++ \
    git \
    cron \
    libbz2-dev \
    libfreetype6-dev \
    libicu-dev \
    zlib1g-dev \
    libcurl4-openssl-dev \
    libcurl3-openssl-dev \
    libxml2 \
    libjpeg-dev \
    libmcrypt-dev \
    libpng-dev \
    libreadline-dev \
    libzip-dev \
    libonig-dev \
    nano \
    procps \
    pkg-config \
    sudo \
    unzip \
    zip \
 && apt-get clean -y

RUN pecl install redis-5.1.1 \
    && docker-php-ext-enable redis

# Install php extensions
RUN docker-php-ext-install \
    bcmath \
    bz2 \
    calendar \
    ctype \
    curl \
    exif \
    gd \
    iconv \
    intl \
    json \
    mbstring \
    mysqli \
    opcache \
    pdo \
    pdo_mysql \
    pcntl \
    session \
    tokenizer \
    zip \
 && docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-install -j$(nproc) gd

RUN echo "ServerName skynet" >> /etc/apache2/apache2.conf

RUN chmod 777 -r "/var/www/html/storage"

RUN a2enmod rewrite headers

# Setup working directory
WORKDIR /var/www/html/public