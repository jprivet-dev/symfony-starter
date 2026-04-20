#!/bin/bash
# ------------------------------------------------------------------
# Script: generate.sh
# Description: Generate all Symfony Starter flavors into their
#              respective branches.
#
# Usage:
#   bash .starter/scripts/generate.sh
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
START_TOTAL=$(date +%s)
LOGS_DIR=".starter/scripts/logs"

BRANCHES=(
#    "minimalist"
#    "minimalist_lts"
#    "webapp"
    "webapp_lts"
#    "webapp_mariadb"
    "webapp_mariadb_lts"
#    "webapp_sqlite"
#    "webapp_sqlite_lts"
#    "api"
#    "api_lts"
#    "easy_admin"
#    "easy_admin_lts"
#    "demo"
)

# ------------------------------------------------------------------
# Flavor functions — one per branch
# ------------------------------------------------------------------

generate_flavor_minimalist() {
    git switch "${WORK_BRANCH}"
    NO_INTERACTION=true make clean_app
    NO_INTERACTION=true make minimalist
}

generate_flavor_minimalist_lts() {
    git switch "${WORK_BRANCH}"
    NO_INTERACTION=true make clean_app
    NO_INTERACTION=true make minimalist@lts
}

generate_flavor_webapp() {
    git switch "${WORK_BRANCH}"
    NO_INTERACTION=true make clean_app
    NO_INTERACTION=true make webapp
}

generate_flavor_webapp_lts() {
    git switch "${WORK_BRANCH}"
    NO_INTERACTION=true make clean_app
    NO_INTERACTION=true make webapp@lts
}

generate_flavor_webapp_mariadb() {
    generate_require_branch "webapp" || return 1
    git switch -C webapp_mariadb webapp
    make switch_to_mariadb
    make health_welcome_to_symfony
}

generate_flavor_webapp_mariadb_lts() {
    generate_require_branch "webapp_lts" || return 1
    git switch -C webapp_mariadb_lts webapp_lts
    make switch_to_mariadb
    make health_welcome_to_symfony
}

generate_flavor_webapp_sqlite() {
    generate_require_branch "webapp" || return 1
    git switch -C webapp_sqlite webapp
    make switch_to_sqlite
    make health_welcome_to_symfony
}

generate_flavor_webapp_sqlite_lts() {
    generate_require_branch "webapp_lts" || return 1
    git switch -C webapp_sqlite_lts webapp_lts
    make switch_to_sqlite
    make health_welcome_to_symfony
}

generate_flavor_api() {
    git switch "${WORK_BRANCH}"
    NO_INTERACTION=true make clean_app
    NO_INTERACTION=true make api
}

generate_flavor_api_lts() {
    git switch "${WORK_BRANCH}"
    NO_INTERACTION=true make clean_app
    NO_INTERACTION=true make api@lts
}

generate_flavor_easy_admin() {
    git switch "${WORK_BRANCH}"
    NO_INTERACTION=true make clean_app
    NO_INTERACTION=true make easy_admin
}

generate_flavor_easy_admin_lts() {
    git switch "${WORK_BRANCH}"
    NO_INTERACTION=true make clean_app
    NO_INTERACTION=true make easy_admin@lts
}

generate_flavor_demo() {
    git switch "${WORK_BRANCH}"
    NO_INTERACTION=true make clean_app
    NO_INTERACTION=true make demo
}

# ------------------------------------------------------------------
# generate_require_branch <branch>
# Check that a base branch exists before deriving from it
# ------------------------------------------------------------------

generate_require_branch() {
    local BRANCH="$1"
    if ! git show-ref --verify --quiet refs/heads/"${BRANCH}"; then
        printf " ${R}⨯${S} Base branch ${Y}${BRANCH}${S} does not exist or failed. Skipping.\n"
        return 1
    fi
    if [ "${RESULTS[${BRANCH}]}" != "ok" ]; then
        printf " ${R}⨯${S} Base branch ${Y}${BRANCH}${S} did not generate successfully. Skipping.\n"
        return 1
    fi
}

# ------------------------------------------------------------------
# generate_flavor <branch>
# ------------------------------------------------------------------

generate_flavor() {
    local BRANCH="$1"
    local FUNC="generate_flavor_${BRANCH}"
    local LOG_FILE="${LOGS_DIR}/${BRANCH}.log"

    printf "\n${Y}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${S}\n"
    printf " ${Y}›${S} Generating: ${G}${BRANCH}${S}\n"
    printf "${Y}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${S}\n\n"

    if ! declare -f "${FUNC}" > /dev/null; then
        printf " ${R}⨯${S} No function defined for branch ${Y}${BRANCH}${S}\n"
        RESULTS["${BRANCH}"]="error"
        HAS_ERROR=1
        return
    fi

    if ${FUNC} 2>"${LOG_FILE}"; then
        RESULTS["${BRANCH}"]="ok"
        rm -f "${LOG_FILE}"
        printf "\n ${G}✔${S} ${BRANCH} generated successfully\n"
    else
        RESULTS["${BRANCH}"]="error"
        HAS_ERROR=1
        printf "\n ${R}⨯${S} ${BRANCH} failed — see ${Y}${LOG_FILE}${S}\n"
    fi
}

# ------------------------------------------------------------------

declare -A RESULTS
HAS_ERROR=0

mkdir -p "${LOGS_DIR}"

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

for BRANCH in "${BRANCHES[@]}"; do
    generate_flavor "${BRANCH}"
done

# --- Return to work branch ---

git switch "${WORK_BRANCH}"

# --- Report ---

END_TOTAL=$(date +%s)
DURATION_TOTAL=$(( END_TOTAL - START_TOTAL ))
MINUTES_TOTAL=$(( DURATION_TOTAL / 60 ))
SECONDS_TOTAL=$(( DURATION_TOTAL % 60 ))

printf "\n${Y}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${S}\n"
printf " ${Y}Report${S}\n"
printf "${Y}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${S}\n\n"

for BRANCH in "${BRANCHES[@]}"; do
    STATUS="${RESULTS[${BRANCH}]}"
    if [ "${STATUS}" = "ok" ]; then
        printf " ${G}✔${S} ${BRANCH}\n"
    elif [ "${STATUS}" = "error" ]; then
        LOG_FILE="${LOGS_DIR}/${BRANCH}.log"
        printf " ${R}⨯${S} ${BRANCH}"
        if [ -f "${LOG_FILE}" ]; then
            printf " — see ${Y}${LOG_FILE}${S}"
        fi
        printf "\n"
    else
        printf " ${Y}›${S} ${BRANCH} (skipped)\n"
    fi
done

printf "\n ⏱️  Total generation time: ${Y}%02dm %02ds${S}\n\n" $MINUTES_TOTAL $SECONDS_TOTAL

if [ "${HAS_ERROR}" -eq 0 ]; then
    printf " ${G}✔${S} All flavors generated successfully. Run ${Y}.starter/scripts/push.sh${S} to push to origin.\n\n"
else
    printf " ${R}⨯${S} Some generations failed. Fix errors before running ${Y}.starter/scripts/push.sh${S}.\n\n"
    exit 1
fi
