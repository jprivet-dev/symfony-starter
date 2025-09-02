#!/bin/bash
# Usage:
#   . generate.sh
# or
#   source generate.sh

# (G)REEN, (R)ED, (Y)ELLOW & RE(S)ET
G='\033[32m'
R='\033[31m'
Y='\033[33m'
S='\033[0m'

#set -e

function generate_version() {
    local current="${1}"
    local command="${2}"
    local branch="${3}"

    printf "\n"
    printf " ${Y}>${S}\n"
    printf " ${Y}>${S} Generate ${command} version in ${branch} branch\n"
    printf " ${Y}>${S}\n"
    printf "\n"

    docker compose down --volumes --rmi all

    if git rev-parse --verify --quiet "${branch}" >/dev/null; then
        printf " ${R}⨯${S} ${branch} branch already exists. Remove it.\n"
        git branch -D "${branch}"
    fi

    git checkout -b "${branch}"
    make "${command}"

    git add .
    git commit -m "Save ${command} version"
    printf " ${G}✔${S} ${command} version saved & pushed\n"

    git checkout "${current}"
}

current_branch=$(git rev-parse --abbrev-ref HEAD)

generate_version "${current_branch}" minimalist minimalist
generate_version "${current_branch}" minimalist@lts minimalist-lts
generate_version "${current_branch}" webapp webapp
generate_version "${current_branch}" webapp@lts webapp-lts
