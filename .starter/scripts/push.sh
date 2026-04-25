#!/bin/bash
# ------------------------------------------------------------------
# Script: push.sh
# Description: Push all Symfony Starter flavor branches to origin.
#
# Usage:
#   bash .starter/scripts/push.sh
#
# Run this script only after a successful .starter/scripts/generate.sh.
# ------------------------------------------------------------------

# (G)REEN, (R)ED, (Y)ELLOW & RE(S)ET
G='\033[32m'
R='\033[31m'
Y='\033[33m'
S='\033[0m'

# --- Branches ---

BRANCHES=(
    "minimalist"
    "minimalist@lts"
    "webapp"
    "webapp@mariadb"
    "webapp@sqlite"
    "webapp@lts"
    "webapp@lts_mariadb"
    "webapp@lts_sqlite"
    "api"
    "api@lts"
    "easy_admin"
    "easy_admin@lts"
    "demo"
    "contrib@6x"
)

printf "\n${Y}--- Symfony Starter - Push All ---${S}\n\n"

HAS_ERROR=0

for BRANCH in "${BRANCHES[@]}"; do
    printf " ${Y}›${S} Pushing ${G}${BRANCH}${S}...\n"
    if git push origin "${BRANCH}" --force; then
        printf " ${G}✔${S} ${BRANCH} pushed successfully\n\n"
    else
        printf " ${R}⨯${S} ${BRANCH} failed to push\n\n"
        HAS_ERROR=1
    fi
done

if [ "${HAS_ERROR}" -eq 0 ]; then
    printf " ${G}✔${S} All branches pushed to origin.\n\n"
else
    printf " ${R}⨯${S} Some branches failed to push.\n\n"
    exit 1
fi
