#!/bin/bash
# ------------------------------------------------------------------
# Script: generate.sh
# Description: Generate all Symfony Starter flavors into their
#              respective branches.
#
# Usage:
#   bash .sh/generate.sh
#
# The script starts from the current branch (your work branch).
# Make sure you are on the right branch before running this script.
# ------------------------------------------------------------------

set -e

# (G)REEN, (R)ED, (Y)ELLOW & RE(S)ET
G='\033[32m'
R='\033[31m'
Y='\033[33m'
S='\033[0m'

WORK_BRANCH=$(git rev-parse --abbrev-ref HEAD)

BRANCHES=(
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

printf "\n${Y}--- Symfony Starter - Generate All ---${S}\n"
printf " ${Y}›${S} Work branch: ${G}${WORK_BRANCH}${S}\n\n"

# --- Delete all target branches ---

printf "${Y}--- Deleting target branches ---${S}\n\n"
for BRANCH in "${BRANCHES[@]}"; do
    if git show-ref --verify --quiet refs/heads/"${BRANCH}"; then
        git branch -D "${BRANCH}"
        printf " ${Y}›${S} Deleted branch ${Y}${BRANCH}${S}\n"
    fi
done

# --- Generate ---

# --- minimalist ---
git switch "${WORK_BRANCH}"
NO_INTERACTION=true make clean_app
NO_INTERACTION=true make minimalist

# --- minimalist@lts ---
#git switch "${WORK_BRANCH}"
#NO_INTERACTION=true make clean_app
#NO_INTERACTION=true make minimalist@lts

# --- webapp ---
#git switch "${WORK_BRANCH}"
#NO_INTERACTION=true make clean_app
#NO_INTERACTION=true make webapp

# --- webapp@lts ---
#git switch "${WORK_BRANCH}"
#NO_INTERACTION=true make clean_app
#NO_INTERACTION=true make webapp@lts

# --- api ---
#git switch "${WORK_BRANCH}"
#NO_INTERACTION=true make clean_app
#NO_INTERACTION=true make api

# --- api@lts ---
#git switch "${WORK_BRANCH}"
#NO_INTERACTION=true make clean_app
#NO_INTERACTION=true make api@lts

# --- easy_admin ---
#git switch "${WORK_BRANCH}"
#NO_INTERACTION=true make clean_app
#NO_INTERACTION=true make easy_admin

# --- easy_admin@lts ---
#git switch "${WORK_BRANCH}"
#NO_INTERACTION=true make clean_app
#NO_INTERACTION=true make easy_admin@lts

# --- demo ---
#git switch "${WORK_BRANCH}"
#NO_INTERACTION=true make clean_app
#NO_INTERACTION=true make demo

# --- Return to work branch ---
git switch "${WORK_BRANCH}"
NO_INTERACTION=true make clean_app

# --- Report ---

printf "\n${Y}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${S}\n"
printf " ${Y}Report${S}\n"
printf "${Y}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${S}\n\n"

for BRANCH in "${BRANCHES[@]}"; do
    if git show-ref --verify --quiet refs/heads/"${BRANCH}"; then
        printf " ${G}✔${S} ${BRANCH}\n"
    else
        printf " ${R}⨯${S} ${BRANCH}\n"
    fi
done

printf "\n ${G}✔${S} All flavors generated successfully. Run ${Y}.sh/push.sh${S} to push to origin.\n\n"
