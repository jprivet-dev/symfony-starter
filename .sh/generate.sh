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

# --- Flavors ---

FLAVORS=(
    "minimalist"
    "minimalist@lts"
    "webapp"
    "webapp@lts"
#    "api"
#    "api@lts"
#    "easy_admin"
#    "easy_admin@lts"
#    "demo"
)

# --- Results ---

declare -A RESULTS
declare -A DURATIONS
HAS_ERROR=0

# --- Generate ---

for FLAVOR in "${FLAVORS[@]}"; do

    printf "\n${Y}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${S}\n"
    printf " ${Y}›${S} Generating: ${G}${FLAVOR}${S}\n"
    printf "${Y}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${S}\n\n"

    # Return to work branch and clean up
    git switch "${WORK_BRANCH}"
    make kill_current_app NO_INTERACTION=true

    FLAVOR_START=$(date +%s)

    if NO_INTERACTION=true make ${FLAVOR}; then
        FLAVOR_END=$(date +%s)
        DURATION=$(( FLAVOR_END - FLAVOR_START ))
        MINUTES=$(( DURATION / 60 ))
        SECONDS=$(( DURATION % 60 ))
        RESULTS["${FLAVOR}"]="ok"
        DURATIONS["${FLAVOR}"]=$(printf "%02dm %02ds" $MINUTES $SECONDS)
        printf "\n ${G}✔${S} ${FLAVOR} generated successfully\n"
    else
        FLAVOR_END=$(date +%s)
        DURATION=$(( FLAVOR_END - FLAVOR_START ))
        MINUTES=$(( DURATION / 60 ))
        SECONDS=$(( DURATION % 60 ))
        RESULTS["${FLAVOR}"]="error"
        DURATIONS["${FLAVOR}"]=$(printf "%02dm %02ds" $MINUTES $SECONDS)
        HAS_ERROR=1
        printf "\n ${R}⨯${S} ${FLAVOR} failed\n"
    fi
done

# --- Return to work branch ---

git switch "${WORK_BRANCH}"

# --- Report ---

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
