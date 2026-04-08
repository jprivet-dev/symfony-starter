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

printf "\n${Y}--- Symfony Starter - Generate All ---${S}\n"
printf " ${Y}›${S} Work branch: ${G}${WORK_BRANCH}${S}\n\n"

# --- minimalist ---
NO_INTERACTION=true make clean_app
git switch -C minimalist "${WORK_BRANCH}"
NO_INTERACTION=true make minimalist

# --- webapp (from minimalist) ---
NO_INTERACTION=true make clean_app
git switch -C webapp minimalist
NO_INTERACTION=true make webapp

# --- api (from minimalist) ---
#git switch -C api minimalist
#NO_INTERACTION=true make api

# --- easy_admin (from minimalist) ---
#git switch -C easy_admin minimalist
#NO_INTERACTION=true make easy_admin

# --- minimalist@lts ---
#git switch -C minimalist@lts "${WORK_BRANCH}"
#NO_INTERACTION=true make minimalist@lts

# --- webapp@lts (from minimalist@lts) ---
#git switch -C webapp@lts minimalist@lts
#NO_INTERACTION=true make webapp@lts

# --- api@lts (from minimalist@lts) ---
#git switch -C api@lts minimalist@lts
#NO_INTERACTION=true make api@lts

# --- easy_admin@lts (from minimalist@lts) ---
#git switch -C easy_admin@lts minimalist@lts
#NO_INTERACTION=true make easy_admin@lts

# --- demo (from work branch) ---
NO_INTERACTION=true make clean_app
git switch -C demo "${WORK_BRANCH}"
NO_INTERACTION=true make demo

# --- Return to work branch ---
git switch "${WORK_BRANCH}"
NO_INTERACTION=true make clean_app

printf "\n ${G}✔${S} All flavors generated successfully. Run ${Y}.sh/push.sh${S} to push to origin.\n\n"
