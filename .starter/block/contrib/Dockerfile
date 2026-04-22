# Contrib PHP extensions
RUN apt-get update && apt-get install -y \
    libxslt1-dev \
    && docker-php-ext-install xsl \
    && rm -rf /var/lib/apt/lists/*
