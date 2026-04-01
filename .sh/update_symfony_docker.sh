#!/bin/bash
# ------------------------------------------------------------------
# Script: update_symfony_docker.sh
# Description: Vendors the latest HEAD of dunglas/symfony-docker
#              directly at the project root, updates the upstream
#              commit SHA in THIRD_PARTY_LICENSES.md, and creates a
#              git commit for full traceability.
#
# Run via Makefile (recommended):
#   make update_symfony_docker
#
# Or directly:
#   .sh/update_symfony_docker.sh
# ------------------------------------------------------------------

set -e

# (G)REEN, (R)ED, (Y)ELLOW & RE(S)ET
G='\033[32m'
R='\033[31m'
Y='\033[33m'
S='\033[0m'

REPOSITORY="git@github.com:dunglas/symfony-docker.git"
CLONE_DIR=".symfony-docker-clone"
LICENSES_FILE="THIRD_PARTY_LICENSES.md"

# --- 1. Cleanup any leftover temp clone ---

if [ -d "${CLONE_DIR}" ]; then
    printf " ${Y}›${S} Removing leftover temp directory ${Y}${CLONE_DIR}${S}...\n"
    rm -rf "${CLONE_DIR}"
fi

# --- 2. Clone ---

printf "\n${Y}--- Cloning ${REPOSITORY} ---${S}\n"
git clone "${REPOSITORY}" "${CLONE_DIR}" --depth 1

UPSTREAM_COMMIT=$(git -C "${CLONE_DIR}" rev-parse HEAD)
printf " ${G}✔${S} Cloned at commit: ${Y}${UPSTREAM_COMMIT}${S}\n"

# --- 3. Sync into project root ---

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

# --- 4. Cleanup temp clone ---

rm -rf "${CLONE_DIR}"
printf " ${G}✔${S} Temp directory removed.\n"

# --- 5. Update THIRD_PARTY_LICENSES.md ---

printf "\n${Y}--- Updating ${LICENSES_FILE} ---${S}\n"

if [ ! -f "${LICENSES_FILE}" ]; then
    printf " ${R}⨯${S} ${LICENSES_FILE} not found. Please create it first.\n"
    exit 1
fi

# Portable: use a temporary file to support both Linux and macOS
TEMP_FILE=$(mktemp)
awk "
    /## dunglas\/symfony-docker/{found=1}
    found && /\*\*Upstream commit:\*\*/{
        sub(/\*\*Upstream commit:\*\* .*/, \"**Upstream commit:** ${UPSTREAM_COMMIT}\");
        found=0
    }
    {print}
" "${LICENSES_FILE}" > "${TEMP_FILE}" && mv "${TEMP_FILE}" "${LICENSES_FILE}"

printf " ${G}✔${S} Upstream commit updated in ${Y}${LICENSES_FILE}${S}\n"

# --- 6. Git commit ---

printf "\n${Y}--- Committing ---${S}\n"
git add .
git commit -m "🤖 [starter] update symfony-docker to dunglas/symfony-docker@${UPSTREAM_COMMIT}"

printf "\n ${G}✔${S} dunglas/symfony-docker updated at ${G}${UPSTREAM_COMMIT}${S}\n\n"
