#!/bin/bash
# Usage:
#   . save.sh
# or
#   source save.sh

TYPE=${1} # minimalist, webapp, api

PHP_VERSION=$(docker compose exec  php php -r "echo phpversion();")
SYMFONY_VERSION=$(php bin/console -V | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+')
# Add Api Platform version only if vendor/api-platform directory exist
API_PLATFORM_VERSION=$(grep -E 'api-platform/symfony/tree/v[0-9.]+"' composer.lock | grep -o 'v[0-9]\+\.[0-9]\+\.[0-9]\+' | sed 's/v//')

BRANCH="${TYPE}-php-${PHP_VERSION}-symfony-${SYMFONY_VERSION}-api-platform-${API_PLATFORM_VERSION}";

echo "${BRANCH}"
