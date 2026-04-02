#!/bin/bash
# ------------------------------------------------------------------
# Script: push.sh
# Description: Push all Symfony Starter flavor branches to origin.
#
# Usage:
#   bash .sh/push.sh
#
# Run this script only after a successful .sh/generate.sh.
# ------------------------------------------------------------------

# (G)REEN, (R)ED, (Y)ELLOW & RE(S)ET
G='\033[32m'
R='\033[31m'
Y='\033[33m'
S='\033[0m'

# --- Flavors ---

FLAVORS=(
    "minimalist"
    "minimalist@lts"
    "webapp"
    "webapp@lts"
    "api"
    "api@lts"
    "easy_admin"
    "easy_admin@lts"
    "demo"
)

printf "\n${Y}--- Symfony Starter - Push All ---${S}\n\n"

HAS_ERROR=0

for FLAVOR in "${FLAVORS[@]}"; do
    printf " ${Y}›${S} Pushing ${G}${FLAVOR}${S}...\n"
    if git push origin "${FLAVOR}" --force; then
        printf " ${G}✔${S} ${FLAVOR} pushed successfully\n\n"
    else
        printf " ${R}⨯${S} ${FLAVOR} failed to push\n\n"
        HAS_ERROR=1
    fi
done

if [ "${HAS_ERROR}" -eq 0 ]; then
    printf " ${G}✔${S} All branches pushed to origin.\n\n"
else
    printf " ${R}⨯${S} Some branches failed to push.\n\n"
    exit 1
fi
