#!/bin/bash
# Usage:
#   . .sh/generate.sh my_command
# or
#   source .sh/generate.sh my_command

command=$1

git switch next &&
    make remove_all &&
    git switch -c "${command}-$(date +"%Y%m%d-%H%M%S")" &&
    make "${command}"
