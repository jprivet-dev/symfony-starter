# Contrib PHP extensions
RUN apt-get update && apt-get install -y \
    libxslt1-dev \
    libgd-dev \
    libzip-dev \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && docker-php-ext-install \
    xsl \
    gd \
    zip \
    intl \
    opcache \
    && rm -rf /var/lib/apt/lists/*
