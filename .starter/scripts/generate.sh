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

generate_flavor_webapp_mariadb() {
    git switch "${WORK_BRANCH}"
    NO_INTERACTION=true make clean_app
    NO_INTERACTION=true make webapp BRANCH=webapp@mariadb
    make switch_to_mariadb
    make health_welcome_to_symfony
}

generate_flavor_webapp_sqlite() {
    git switch "${WORK_BRANCH}"
    NO_INTERACTION=true make clean_app
    NO_INTERACTION=true make webapp BRANCH=webapp@sqlite
    make switch_to_sqlite
    make health_welcome_to_symfony
}

generate_flavor_webapp_lts() {
    git switch "${WORK_BRANCH}"
    NO_INTERACTION=true make clean_app
    NO_INTERACTION=true make webapp@lts
}

generate_flavor_webapp_lts_mariadb() {
    git switch "${WORK_BRANCH}"
    NO_INTERACTION=true make clean_app
    NO_INTERACTION=true make webapp@lts BRANCH=webapp@lts_mariadb
    make switch_to_mariadb
    make health_welcome_to_symfony
}

generate_flavor_webapp_lts_sqlite() {
    git switch "${WORK_BRANCH}"
    NO_INTERACTION=true make clean_app
    NO_INTERACTION=true make webapp@lts BRANCH=webapp@lts_sqlite
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

generate_flavor_contrib_6x() {
    git switch "${WORK_BRANCH}"
    NO_INTERACTION=true make clean_app
    NO_INTERACTION=true make contrib@6x
}

# ------------------------------------------------------------------
# generate_flavor <branch>
# ------------------------------------------------------------------

generate_flavor() {
    local BRANCH="$1"
    local FUNC="generate_flavor_${BRANCH//@/_}"
    FUNC="${FUNC//-/_}"
    local LOG_FILE="${LOGS_DIR}/${BRANCH}.log"

    printf "\n${Y}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${S}\n"
    printf " ${Y}›${S} Generating: ${G}${BRANCH}${S}\n"
    printf "${Y}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${S}\n\n"

    if ! declare -f "${FUNC}" >/dev/null; then
        printf " ${R}⨯${S} No function defined for branch ${Y}${BRANCH}${S}\n"
        RESULTS["${BRANCH}"]="error"
        HAS_ERROR=1
        return
    fi

    if ${FUNC} >"${LOG_FILE}" 2>&1; then
        RESULTS["${BRANCH}"]="ok"
        printf "\n ${G}✔${S} ${BRANCH} generated successfully — see ${Y}${LOG_FILE}${S}\n"
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
DURATION_TOTAL=$((END_TOTAL - START_TOTAL))
MINUTES_TOTAL=$((DURATION_TOTAL / 60))
SECONDS_TOTAL=$((DURATION_TOTAL % 60))

printf "\n${Y}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${S}\n"
printf " ${Y}Report${S}\n"
printf "${Y}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${S}\n\n"

for BRANCH in "${BRANCHES[@]}"; do
    STATUS="${RESULTS[${BRANCH}]}"
    if [ "${STATUS}" = "ok" ]; then
        printf " ${G}✔${S} ${BRANCH} — ${Y}${LOGS_DIR}/${BRANCH}.log${S}\n"
    elif [ "${STATUS}" = "error" ]; then
        printf " ${R}⨯${S} ${BRANCH} — ${Y}${LOGS_DIR}/${BRANCH}.log${S}\n"
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
