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

declare -A RESULTS
HAS_ERROR=0

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

# ------------------------------------------------------------------
# generate_flavor <flavor>
# ------------------------------------------------------------------

generate_flavor() {
    local FLAVOR="$1"

    printf "\n${Y}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${S}\n"
    printf " ${Y}›${S} Generating: ${G}${FLAVOR}${S}\n"
    printf "${Y}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${S}\n\n"

    git switch "${WORK_BRANCH}"
    NO_INTERACTION=true make clean_app

    if NO_INTERACTION=true make ${FLAVOR}; then
        RESULTS["${FLAVOR}"]="ok"
        printf "\n ${G}✔${S} ${FLAVOR} generated successfully\n"
    else
        RESULTS["${FLAVOR}"]="error"
        HAS_ERROR=1
        printf "\n ${R}⨯${S} ${FLAVOR} failed\n"
    fi
}

# --- Generate ---

generate_flavor "minimalist"
#generate_flavor "minimalist@lts"
#generate_flavor "webapp"
#generate_flavor "webapp@lts"
#generate_flavor "api"
#generate_flavor "api@lts"
#generate_flavor "easy_admin"
#generate_flavor "easy_admin@lts"
generate_flavor "demo"

# --- Return to work branch ---

git switch "${WORK_BRANCH}"
NO_INTERACTION=true make clean_app

# --- Report ---

printf "\n${Y}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${S}\n"
printf " ${Y}Report${S}\n"
printf "${Y}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${S}\n\n"

for BRANCH in "${BRANCHES[@]}"; do
    STATUS="${RESULTS[${BRANCH}]}"
    if [ "${STATUS}" = "ok" ]; then
        printf " ${G}✔${S} ${BRANCH}\n"
    elif [ "${STATUS}" = "error" ]; then
        printf " ${R}⨯${S} ${BRANCH}\n"
    else
        printf " ${Y}›${S} ${BRANCH} (skipped)\n"
    fi
done

printf "\n"

if [ "${HAS_ERROR}" -eq 0 ]; then
    printf " ${G}✔${S} All flavors generated successfully. Run ${Y}.sh/push.sh${S} to push to origin.\n\n"
else
    printf " ${R}⨯${S} Some generations failed. Fix errors before running ${Y}.sh/push.sh${S}.\n\n"
    exit 1
fi
