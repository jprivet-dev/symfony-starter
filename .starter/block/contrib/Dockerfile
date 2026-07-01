# Contrib PHP extensions
RUN apt-get update && apt-get install -y \
    libxslt1-dev \
    libgd-dev \
    libzip-dev \
    libicu-dev \
    && rm -rf /var/lib/apt/lists/*

# Install native extensions with explicit clean to avoid 'modules/*' error
RUN docker-php-ext-configure xsl && docker-php-ext-install xsl
RUN docker-php-ext-configure gd && docker-php-ext-install gd
RUN docker-php-ext-configure zip && docker-php-ext-install zip
RUN docker-php-ext-configure intl && docker-php-ext-install intl
