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
    local current=${1}
    local command=${2}
    local branch=${3}

    printf "\n${Y}Generate new version${S}"
    printf "\n${Y}--------------------${S}\n\n"

    printf " ${Y}>>>${S} ${command} version\n"

    if git rev-parse --verify --quiet "${branch}" >dev/null; then
        printf " ${R}⨯${S} ${branch} branch already exists. Remove it.\n"
        git branch -D "${branch}"
    fi

    git new "${branch}"
    git checkout "${branch}"

    make "${command}"

    git add .
    git commit -m "Save ${command} version"
    git push origin "${branch}" --force-with-lease

    printf " ${G}✔${S} ${command} version saved & pushed\n"

    git checkout "${current}"
}

current_branch=$(git rev-parse --abbrev-ref HEAD)

generate_version "${current_branch}" minimalist minimalist
generate_version "${current_branch}" minimalist@lts minimalist-lts
generate_version "${current_branch}" webapp webapp
generate_version "${current_branch}" webapp@lts webapp-lts
