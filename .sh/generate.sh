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

printf "\n${Y}--- Symfony Starter - Generate All ---${S}\n"
printf " ${Y}›${S} Work branch: ${G}${WORK_BRANCH}${S}\n\n"

# --- Results ---

declare -A RESULTS
declare -A DURATIONS
HAS_ERROR=0

# ------------------------------------------------------------------
# run_flavor <branch_from> <make_command> <branch_name>
# ------------------------------------------------------------------
run_flavor() {
    local BRANCH_FROM="$1"
    local COMMAND="$2"
    local BRANCH="$3"

    printf "\n${Y}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${S}\n"
    printf " ${Y}›${S} Generating: ${G}${BRANCH}${S} (from: ${Y}${BRANCH_FROM}${S})\n"
    printf "${Y}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${S}\n\n"

    git switch -C "${BRANCH}" "${BRANCH_FROM}"

    local START=$(date +%s)

    if NO_INTERACTION=true make ${COMMAND}; then
        local END=$(date +%s)
        local DURATION=$(( END - START ))
        RESULTS["${BRANCH}"]="ok"
        DURATIONS["${BRANCH}"]=$(printf "%02dm %02ds" $(( DURATION / 60 )) $(( DURATION % 60 )))
        printf "\n ${G}✔${S} ${BRANCH} generated successfully\n"
    else
        local END=$(date +%s)
        local DURATION=$(( END - START ))
        RESULTS["${BRANCH}"]="error"
        DURATIONS["${BRANCH}"]=$(printf "%02dm %02ds" $(( DURATION / 60 )) $(( DURATION % 60 )))
        HAS_ERROR=1
        printf "\n ${R}⨯${S} ${BRANCH} failed\n"
    fi
}

# --- Generate ---

# 1. minimalist from work branch
run_flavor "${WORK_BRANCH}" "minimalist" "minimalist"

# 2. webapp, api, easy_admin from minimalist
run_flavor "minimalist" "webapp"      "webapp"
run_flavor "minimalist" "api"         "api"
run_flavor "minimalist" "easy_admin"  "easy_admin"

# 3. minimalist@lts from work branch
run_flavor "${WORK_BRANCH}" "minimalist@lts" "minimalist@lts"

# 4. webapp@lts, api@lts, easy_admin@lts from minimalist@lts
run_flavor "minimalist@lts" "webapp@lts"     "webapp@lts"
run_flavor "minimalist@lts" "api@lts"        "api@lts"
run_flavor "minimalist@lts" "easy_admin@lts" "easy_admin@lts"

# 5. demo from work branch
run_flavor "${WORK_BRANCH}" "demo" "demo"

# --- Return to work branch ---

git switch "${WORK_BRANCH}"

# --- Report ---

FLAVORS=(
    "minimalist"
    "webapp"
    "api"
    "easy_admin"
    "minimalist@lts"
    "webapp@lts"
    "api@lts"
    "easy_admin@lts"
    "demo"
)

printf "\n${Y}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${S}\n"
printf " ${Y}Report${S}\n"
printf "${Y}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${S}\n\n"

for FLAVOR in "${FLAVORS[@]}"; do
    STATUS="${RESULTS[${FLAVOR}]}"
    DURATION="${DURATIONS[${FLAVOR}]}"
    if [ "${STATUS}" = "ok" ]; then
        printf " ${G}✔${S} %-40s ${Y}%s${S}\n" "${FLAVOR}" "${DURATION}"
    else
        printf " ${R}⨯${S} %-40s ${Y}%s${S}\n" "${FLAVOR}" "${DURATION}"
    fi
done

printf "\n"

if [ "${HAS_ERROR}" -ne 0 ]; then
    printf " ${R}⨯${S} Some generations failed. Run ${Y}.sh/push.sh${S} only if all succeeded.\n\n"
    exit 1
fi

printf " ${G}✔${S} All flavors generated successfully. Run ${Y}.sh/push.sh${S} to push to origin.\n\n"
