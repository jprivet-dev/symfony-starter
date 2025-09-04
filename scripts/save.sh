#!/bin/bash
# This script creates a new branch with the current project's versions.
#
# Usage:
#   . save.sh
# or
#   source save.sh

echo "Please choose a project type:"
echo "1. minimalist"
echo "2. webapp"
echo "3. api"
echo "Enter your choice (1, 2, or 3):"

read -r CHOICE

case "$CHOICE" in
1)
    TYPE="minimalist"
    ;;
2)
    TYPE="webapp"
    ;;
3)
    TYPE="api"
    ;;
*)
    echo "Invalid choice. The script will stop."
    sleep 1
    exit 1
    ;;
esac

BRANCH_NAME="${TYPE}"

TIMESTAMP=$(date +"%s")
PHP_VERSION=$(docker compose exec -T php php -r "echo phpversion();")
SYMFONY_VERSION=$(docker compose exec -T php php bin/console -V | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
API_PLATFORM_VERSION=""

# Check if the project uses Api Platform
if [ "$TYPE" = "api" ] || [ "$TYPE" = "webapp" ]; then
    # Check if composer.lock exists
    if [ ! -f "composer.lock" ]; then
        echo "Error: composer.lock file not found."
        sleep 1
        exit 1
    fi

    # Get the Api Platform version
    if grep -q "api-platform/symfony" composer.lock; then
        API_PLATFORM_VERSION=$(grep -E 'api-platform/symfony/tree/v[0-9.]+"' composer.lock | grep -o 'v[0-9]\+\.[0-9]\+\.[0-9]\+' | sed 's/v//' | head -n 1)
        if [ -z "$API_PLATFORM_VERSION" ]; then
            echo "Warning: Api Platform version could not be found."
        fi
    fi
fi

# Build the branch name
BRANCH="${BRANCH_NAME}-php-${PHP_VERSION}-symfony-${SYMFONY_VERSION}"
if [ -n "$API_PLATFORM_VERSION" ]; then
    BRANCH="${BRANCH}-api-platform-${API_PLATFORM_VERSION}"
fi

BRANCH="${BRANCH}-${TIMESTAMP}"

echo "Generating branch: ${BRANCH}"

# Confirmation step
echo "Do you want to proceed with the branch creation and save? (y/n)"
read -r CONFIRMATION
if [[ ! "$CONFIRMATION" =~ ^[Yy]$ ]]; then
    echo "Action cancelled. No branch was created."
    sleep 1
    exit 0
fi

git checkout -b "${BRANCH}"
git add .
git commit -m "Generated project for ${BRANCH}"

echo "Branch ${BRANCH} has been created."
