#!/bin/bash
# ------------------------------------------------------------------
# Script: update_symfony_docker.sh
# Description: Vendors the latest HEAD of dunglas/symfony-docker
#              directly at the project root, updates the upstream
#              commit SHA in .starter/UPSTREAM, and creates a
#              git commit for full traceability.
#
# Run via Makefile (recommended):
#   make update_symfony_docker
#
# Or directly:
#   .starter/scripts/update_symfony_docker.sh
# ------------------------------------------------------------------

set -e

# (G)REEN, (R)ED, (Y)ELLOW & RE(S)ET
G='\033[32m'
R='\033[31m'
Y='\033[33m'
S='\033[0m'

REPOSITORY="git@github.com:dunglas/symfony-docker.git"
CLONE_DIR=".symfony-docker-clone"
UPSTREAM_FILE=".starter/UPSTREAM"

# --- 1. Check current upstream commit ---

printf "\n${Y}--- Checking current upstream commit ---${S}\n"

CURRENT_COMMIT=""
if [ -f "${UPSTREAM_FILE}" ]; then
    CURRENT_COMMIT=$(cat "${UPSTREAM_FILE}")
    printf " ${Y}›${S} Current commit: ${Y}${CURRENT_COMMIT}${S}\n"
else
    printf " ${Y}›${S} ${UPSTREAM_FILE} not found, first run.\n"
fi

# --- 2. Cleanup any leftover temp clone ---

if [ -d "${CLONE_DIR}" ]; then
    printf " ${Y}›${S} Removing leftover temp directory ${Y}${CLONE_DIR}${S}...\n"
    rm -rf "${CLONE_DIR}"
fi

# --- 3. Clone ---

printf "\n${Y}--- Cloning ${REPOSITORY} ---${S}\n"
git clone "${REPOSITORY}" "${CLONE_DIR}" --depth 1

UPSTREAM_COMMIT=$(git -C "${CLONE_DIR}" rev-parse HEAD)
printf " ${G}✔${S} Cloned at commit: ${Y}${UPSTREAM_COMMIT}${S}\n"

# --- 4. Compare commits ---

if [ "${CURRENT_COMMIT}" = "${UPSTREAM_COMMIT}" ]; then
    printf "\n ${G}✔${S} Already up to date at ${G}${UPSTREAM_COMMIT}${S}. Nothing to do.\n\n"
    rm -rf "${CLONE_DIR}"
    exit 0
fi

# --- 5. Sync into project root ---

printf "\n${Y}--- Syncing into project root ---${S}\n"

rsync -av \
    --exclude=".devcontainer" \
    --exclude=".editorconfig" \
    --exclude=".git" \
    --exclude=".gitattributes" \
    --exclude=".github" \
    --exclude="docs" \
    --exclude="LICENSE" \
    --exclude="README.md" \
    --exclude="UPSTREAM_COMMIT" \
    "${CLONE_DIR}/" .

printf " ${G}✔${S} dunglas/symfony-docker synced at the project root.\n"

# --- 6. Cleanup temp clone ---

rm -rf "${CLONE_DIR}"
printf " ${G}✔${S} Temp directory removed.\n"

# --- 7. Update .starter/UPSTREAM ---

printf "\n${Y}--- Updating ${UPSTREAM_FILE} ---${S}\n"
echo "${UPSTREAM_COMMIT}" > "${UPSTREAM_FILE}"
printf " ${G}✔${S} Upstream commit recorded in ${Y}${UPSTREAM_FILE}${S}\n"

# --- 8. Update README badges ---

printf "\n${Y}--- Updating README badges ---${S}\n"

# Update dunglas/symfony-docker badge
SHORT_COMMIT=$(echo "${UPSTREAM_COMMIT}" | cut -c1-8)
TEMP_FILE=$(mktemp)
sed "s|dunglas%2Fsymfony--docker-[a-f0-9]*-|dunglas%2Fsymfony--docker-${SHORT_COMMIT}-|g" README.md > "${TEMP_FILE}" && mv "${TEMP_FILE}" README.md
printf " ${G}✔${S} dunglas/symfony-docker badge updated to ${Y}${SHORT_COMMIT}${S}\n"

# Update PHP badge
PHP_VERSION=$(grep "^FROM dunglas/frankenphp" Dockerfile | grep -oP 'php\K[0-9]+\.[0-9]+')
if [ -n "${PHP_VERSION}" ]; then
    TEMP_FILE=$(mktemp)
    sed "s|PHP-[0-9]*\.[0-9]*-|PHP-${PHP_VERSION}-|g" README.md > "${TEMP_FILE}" && mv "${TEMP_FILE}" README.md
    printf " ${G}✔${S} PHP badge updated to ${Y}${PHP_VERSION}${S}\n"
else
    printf " ${Y}›${S} PHP version not found in Dockerfile, badge not updated.\n"
fi

# --- 9. Git commit ---

printf "\n${Y}--- Committing ---${S}\n"
git add .
git commit -m "🤖 [starter] update symfony-docker to dunglas/symfony-docker@${UPSTREAM_COMMIT}"

printf "\n ${G}✔${S} dunglas/symfony-docker updated at ${G}${UPSTREAM_COMMIT}${S}\n\n"
