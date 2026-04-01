#!/bin/bash
# ------------------------------------------------------------------
# Script: update_symfony_demo.sh
# Description: Vendors the latest HEAD of symfony/demo
#              into .symfony-demo/, records the upstream commit SHA
#              into .symfony-demo/UPSTREAM_COMMIT, and creates a
#              git commit for full traceability.
#
# Run via Makefile (recommended):
#   make update_symfony_demo
#
# Or directly:
#   .sh/update_symfony_demo.sh
# ------------------------------------------------------------------

set -e

# (G)REEN, (R)ED, (Y)ELLOW & RE(S)ET
G='\033[32m'
R='\033[31m'
Y='\033[33m'
S='\033[0m'

REPOSITORY="git@github.com:symfony/demo.git"
VENDOR_DIR=".symfony-demo"
CLONE_DIR=".symfony-demo-clone"

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

# --- 3. Sync into .symfony-demo/ (full copy, including LICENSE & README.md) ---

printf "\n${Y}--- Vendoring into ${VENDOR_DIR}/ ---${S}\n"

mkdir -p "${VENDOR_DIR}"

rsync -av \
    --delete \
    --exclude=".git" \
    "${CLONE_DIR}/" "${VENDOR_DIR}/"

# --- 4. Record the upstream commit SHA ---

echo "${UPSTREAM_COMMIT}" > "${VENDOR_DIR}/UPSTREAM_COMMIT"
printf " ${G}✔${S} Upstream commit recorded in ${Y}${VENDOR_DIR}/UPSTREAM_COMMIT${S}\n"

# --- 5. Cleanup temp clone ---

rm -rf "${CLONE_DIR}"
printf " ${G}✔${S} Temp directory removed.\n"

# --- 6. Git commit ---

printf "\n${Y}--- Committing ---${S}\n"
git add "${VENDOR_DIR}"
git commit -m "🤖 [starter] update symfony-demo to symfony/demo@${UPSTREAM_COMMIT}"

printf "\n ${G}✔${S} symfony/demo vendored at ${G}${UPSTREAM_COMMIT}${S}\n\n"
