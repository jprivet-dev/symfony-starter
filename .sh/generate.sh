#!/bin/bash
# Usage:
#   . .sh/generate.sh
# or
#   source .sh/generate.sh

function generate() {
    command=$1
    git switch next &&
        git switch -c "${command}-$(date +"%Y%m%d-%H%M%S")" &&
        make "${command}"
}

generate api
generate api@lts
